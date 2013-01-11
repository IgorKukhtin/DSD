-- Table: "ObjectStringDesc"

-- DROP TABLE "ObjectStringDesc";

CREATE TABLE "ObjectStringDesc"
(
  "Id" serial NOT NULL,
  "ObjectDesc" integer,
  "Name" tlongvarchar,
  CONSTRAINT "ObjectStringDescId" PRIMARY KEY ("Id")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "ObjectStringDesc"
  OWNER TO postgres;