-- View: Object_ImportExportLink_View

-- DROP VIEW IF EXISTS Object_ImportExportLink_View CASCADE;

CREATE OR REPLACE VIEW Object_ImportExportLink_View AS
  SELECT 
       Object_ImportExportLink.Id 
     , Object_ImportExportLink.ObjectCode   AS IntegerKey
     , Object_ImportExportLink.ValueData    AS StringKey
     , ObjectLink_ObjectMain.ChildObjectId  AS MainId
     , ObjectLink_ObjectChild.ChildObjectId AS ValueId
     , ObjectMain.ValueData                 AS ObjectMainName
     , ObjectDescMain.ItemName              AS DescMainName
     , ObjectChild.ValueData                AS ObjectChildName
     , ObjectDescChild.ItemName             AS DescChildName
     , ObjectLink_LinkType.ChildObjectId    AS LinkTypeId
     , LinkType.ValueData                   AS LinkTypeName
     , ObjectBlob_Text.ValueData            AS SomeText
     , Object_ImportExportLink.isErased     AS isErased
   FROM Object AS Object_ImportExportLink
       LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                            ON ObjectLink_ObjectMain.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()
       LEFT JOIN Object AS ObjectMain ON ObjectMain.Id = ObjectLink_ObjectMain.ChildObjectId
       LEFT JOIN ObjectDesc AS ObjectDescMain ON ObjectDescMain.Id = ObjectMain.DescId

       LEFT JOIN ObjectLink AS ObjectLink_ObjectChild
                            ON ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()
       LEFT JOIN Object AS ObjectChild ON ObjectChild.Id = ObjectLink_ObjectChild.ChildObjectId
       LEFT JOIN ObjectDesc AS ObjectDescChild ON ObjectDescChild.Id = ObjectChild.DescId

       LEFT JOIN ObjectLink AS ObjectLink_LinkType
                            ON ObjectLink_LinkType.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_LinkType.DescId = zc_ObjectLink_ImportExportLink_LinkType()
       LEFT JOIN Object AS LinkType ON LinkType.Id = ObjectLink_LinkType.ChildObjectId

       LEFT JOIN ObjectBlob AS ObjectBlob_Text
                            ON ObjectBlob_Text.ObjectId = Object_ImportExportLink.Id
                           AND ObjectBlob_Text.DescId = zc_ObjectBlob_ImportExportLink_Text()

  WHERE Object_ImportExportLink.DescId = zc_Object_ImportExportLink();


ALTER TABLE Object_ImportExportLink_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 18.08.17         * isErased
 08.12.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM gpSelect_Object_ImportExportLink
