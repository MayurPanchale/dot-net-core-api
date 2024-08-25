# Use the .NET SDK image for the build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0.302 AS build
WORKDIR /source

# Copy solution file and project file, then restore dependencies
COPY *.sln ./
COPY SimpleCrudApp.csproj ./
RUN dotnet restore

# Copy the rest of the source code and build the application
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

# Expose port 8081
EXPOSE 8081

# Final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app ./

# Set the environment variable for ASP.NET Core
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "SimpleCrudApp.dll"]
