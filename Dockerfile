#Build stage
FROM microsoft/aspnetcore-build:2 AS build-env

WORKDIR /generator

# restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj

RUN ls -alR

# copy src
COPY . .

# test
RUN dotnet test tests/tests.csproj

# publish
RUN dotnet publish api/api.csproj -o /publish -c Release -r linux-x64

# RUN dotnet publish api/api.csproj -o /publish
# RUN dotnet publish api/api.csproj -o /publish -r linux-x64  # try it without -c Release

# Runtime stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT [ "dotnet", "api.dll" ]
