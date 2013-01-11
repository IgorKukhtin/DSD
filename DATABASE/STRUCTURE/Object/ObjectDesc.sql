CREATE TABLE "ObjectDesc"
(
  "Id" serial NOT NULL,
  "Name" tlongvarchar,
  CONSTRAINT "ID" PRIMARY KEY ("Id")
)
WITH (
  OIDS=TRUE
);
