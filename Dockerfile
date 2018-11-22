FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["DockerApiTest/DockerApiTest.csproj", "DockerApiTest/"]
RUN dotnet restore "DockerApiTest/DockerApiTest.csproj"
COPY . .
WORKDIR "/src/DockerApiTest"
RUN dotnet build "DockerApiTest.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerApiTest.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerApiTest.dll"]