FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY MyApi/MyApi.csproj MyApi/
RUN dotnet restore "MyApi/MyApi.csproj"

COPY . .
WORKDIR /src/MyApi
RUN dotnet build "MyApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5050

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyApi.dll"]