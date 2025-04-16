# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . ./

# Restore dependencies
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o /out

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /out .

# Expose the port the app runs on
# EXPOSE 5000

# Set the entry point for the application
ENTRYPOINT ["dotnet", "BlazorLearning.dll"]

# install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*
# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf
# Copy the static files to the nginx directory
CMD ["nginx", "-g", "daemon off;"]
# Expose the port for nginx
EXPOSE 80