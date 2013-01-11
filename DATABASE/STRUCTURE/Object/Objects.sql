-- Table: "Objects"

-- DROP TABLE "Objects";

CREATE TABLE "Objects"
(
  "Id" serial NOT NULL,
  "Name" tlongvarchar,
  "DescId" integer,
  "ObjectCode" integer,
  CONSTRAINT "ObjectsId" PRIMARY KEY ("Id"),
  CONSTRAINT "Objects_ObjectDesc" FOREIGN KEY ("DescId")
      REFERENCES "ObjectDesc" ("Id") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Objects"
  OWNER TO postgres;

-- Index: "idx_Objects_ObjectDesc"

-- DROP INDEX "idx_Objects_ObjectDesc";

CREATE INDEX "idx_Objects_ObjectDesc"
  ON "Objects"
  USING btree
  ("DescId");
