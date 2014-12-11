-- View: Object_ImportExportLink_View

CREATE OR REPLACE VIEW Object_ImportExportLink_View AS
  SELECT 
       Object_ImportExportLink.Id 
     , Object_ImportExportLink.ObjectCode   AS IntegerKey
     , Object_ImportExportLink.ValueData    AS StringKey
     , ObjectLink_ObjectMain.ChildObjectId  AS MainId
     , ObjectLink_ObjectChild.ChildObjectId AS ValueId
     , ObjectMain.ValueData                 AS ObjectMainName
     , ObjectChild.ValueData                AS ObjectChildName
     , ObjectLink_LinkType.ChildObjectId    AS LinkTypeId
     , LinkType.ValueData                   AS LinkTypeName
   FROM Object AS Object_ImportExportLink
       LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                            ON ObjectLink_ObjectMain.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()
       LEFT JOIN Object AS ObjectMain ON ObjectMain.Id = ObjectLink_ObjectMain.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_ObjectChild
                            ON ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()
       LEFT JOIN Object AS ObjectChild ON ObjectChild.Id = ObjectLink_ObjectChild.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_LinkType
                            ON ObjectLink_LinkType.ObjectId = Object_ImportExportLink.Id
                           AND ObjectLink_LinkType.DescId = zc_ObjectLink_ImportExportLink_LinkType()
       LEFT JOIN Object AS LinkType ON LinkType.Id = ObjectLink_LinkType.ChildObjectId

 WHERE Object_ImportExportLink.DescId = zc_Object_ImportExportLink();


ALTER TABLE Object_ImportExportLink_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 08.12.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_ImportExportLink_View