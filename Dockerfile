#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Add the following lines to create a non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
RUN chown -R appuser:appgroup /app

EXPOSE 80
EXPOSE 443
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["GoT WIki.csproj", "."]
RUN dotnet restore "./GoT WIki.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "GoT WIki.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GoT WIki.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GoT WIki.dll"]