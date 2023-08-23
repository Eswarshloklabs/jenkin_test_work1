#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["jenkin_work/jenkin_work.csproj", "jenkin_work/"]
RUN dotnet restore "jenkin_work/jenkin_work.csproj"
COPY . .
WORKDIR "/src/jenkin_work"
RUN dotnet build "jenkin_work.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jenkin_work.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jenkin_work.dll"]