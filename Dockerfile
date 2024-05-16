# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project files and restore dependencies
COPY ["Server/BlazorAspCookingAgenda.Server.csproj", "Server/"]
COPY ["Client/BlazorAspCookingAgenda.Client.csproj", "Client/"]
COPY ["Shared/BlazorAspCookingAgenda.Shared.csproj", "Shared/"]
RUN dotnet restore "Server/BlazorAspCookingAgenda.Server.csproj"

# Copy the entire project and build
COPY . .
WORKDIR "/src/Server"
RUN dotnet build "BlazorAspCookingAgenda.Server.csproj" -c Release -o /app/build

# Stage 2: Publish the application
FROM build AS publish
RUN dotnet publish "BlazorAspCookingAgenda.Server.csproj" -c Release -o /app/publish

# Stage 3: Final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose ports
EXPOSE 80
EXPOSE 443

# Entry point
ENTRYPOINT ["dotnet", "BlazorAspCookingAgenda.Server.dll"]
