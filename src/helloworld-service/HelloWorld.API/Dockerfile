FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ./HelloWorld.API.csproj helloworld-service/HelloWorld.API/
RUN dotnet restore helloworld-service/HelloWorld.API/HelloWorld.API.csproj
COPY . helloworld-service/HelloWorld.API/
WORKDIR /src/helloworld-service/HelloWorld.API
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWorld.API.dll"]