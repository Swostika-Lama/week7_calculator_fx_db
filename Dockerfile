# Use OpenJDK 21
FROM eclipse-temurin:21-jdk

# Set display for X11 forwarding
ENV DISPLAY=host.docker.internal:0

# Install required libraries
RUN apt-get update && \
    apt-get install -y \
        maven wget unzip \
        libgtk-3-0 libgl1 libgl1-mesa-dri libx11-6 libxtst6 libxi6 libxrender1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download JavaFX SDK (ARM64 for Apple Silicon)
RUN wget https://download2.gluonhq.com/openjfx/21/openjfx-21_linux-aarch64_bin-sdk.zip -O /tmp/javafx.zip && \
    unzip /tmp/javafx.zip -d /opt && \
    rm /tmp/javafx.zip

# Set JavaFX path
ENV JAVAFX_HOME=/opt/javafx-sdk-21

WORKDIR /app

# Copy Maven files first (for caching)
COPY pom.xml .

# Download dependencies
RUN mvn -q -e -DskipTests dependency:go-offline

# Copy source
COPY src ./src

# Build application
RUN mvn clean package -DskipTests

# Run JavaFX app
CMD ["java", \
"-Dprism.order=sw", \
"-Dprism.verbose=true", \
"-Djava.library.path=/opt/javafx-sdk-21/lib", \
"--module-path", "/opt/javafx-sdk-21/lib", \
"--add-modules", "javafx.controls,javafx.fxml", \
"-jar", "target/sum-product_fx-1.0-SNAPSHOT.jar"]