# ------------------------
# Runtime image
# ------------------------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:80

# ------------------------
# Build image
# ------------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj first (better caching)
COPY MyApp.csproj ./
RUN dotnet restore MyApp.csproj

# Copy rest of source
COPY . ./
RUN dotnet publish MyApp.csproj -c Release -o /app/publish

# ------------------------
# Final image
# ------------------------
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
