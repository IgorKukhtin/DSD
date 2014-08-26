-- View: Object_ToolsWeighing_View

-- DROP VIEW IF EXISTS Object_ToolsWeighing_View;

CREATE OR REPLACE VIEW Object_ToolsWeighing_View AS
       SELECT
             Object_ToolsWeighing.Id                AS Id
           , Object_ToolsWeighing.DescId            AS DescId
           , Object_ToolsWeighing.ObjectCode        AS Code
           , Object_ToolsWeighing.ValueData         AS ValueData
           , OL_ToolsWeighing_Parent.ChildObjectId  AS ParentId
           , Object_Parent.ObjectCode               AS ParentCode
           , Object_Parent.ValueData                AS ParentName
           , Object_ToolsWeighing.AccessKeyId       AS AccessKeyId
           , OS_ToolsWeighing_NameFull.ValueData    AS NameFull
           , OS_ToolsWeighing_Name.ValueData        AS Name
           , OS_ToolsWeighing_NameUser.ValueData    AS NameUser
           , Object_ToolsWeighing.isErased          AS isErased
           , ObjectBoolean_isLeaf.ValueData         AS isLeaf
       FROM Object AS Object_ToolsWeighing

           LEFT JOIN ObjectLink AS OL_ToolsWeighing_Parent
                                ON OL_ToolsWeighing_Parent.ObjectId = Object_ToolsWeighing.Id
                               AND OL_ToolsWeighing_Parent.DescId = zc_ObjectLink_ToolsWeighing_Parent()

           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = OL_ToolsWeighing_Parent.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_ToolsWeighing.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

           LEFT JOIN ObjectString AS OS_ToolsWeighing_NameFull
                                  ON OS_ToolsWeighing_NameFull.ObjectId = Object_ToolsWeighing.Id
                                 AND OS_ToolsWeighing_NameFull.DescId = zc_ObjectString_ToolsWeighing_NameFull()

           LEFT JOIN ObjectString AS OS_ToolsWeighing_Name
                                  ON OS_ToolsWeighing_Name.ObjectId = Object_ToolsWeighing.Id
                                 AND OS_ToolsWeighing_Name.DescId = zc_ObjectString_ToolsWeighing_Name()

           LEFT JOIN ObjectString AS OS_ToolsWeighing_NameUser
                                  ON OS_ToolsWeighing_NameUser.ObjectId = Object_ToolsWeighing.Id
                                 AND OS_ToolsWeighing_NameUser.DescId = zc_ObjectString_ToolsWeighing_NameUser()



       WHERE Object_ToolsWeighing.DescId = zc_Object_ToolsWeighing();

ALTER TABLE Object_ToolsWeighing_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.
 12.03.14                                                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_ToolsWeighing_View