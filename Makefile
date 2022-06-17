
GO_CMD?=go

default: neo4j-database-plugin

neo4j-database-plugin:
	@CGO_ENABLED=0 $(GO_CMD) build -o ./bin/neo4j-database-plugin && sha256sum ./bin/neo4j-database-plugin
