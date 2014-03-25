-- View: Object_GoodsKindWeighing_View

-- DROP VIEW IF EXISTS Object_GoodsKindWeighing_View;

CREATE OR REPLACE VIEW Object_GoodsKindWeighing_View AS
       SELECT
             Object_GoodsKindWeighing.Id                AS Id
           , Object_GoodsKindWeighing.DescId            AS DescId
           , Object_GoodsKindWeighing.ObjectCode        AS Code
           , Object_GoodsKindWeighing.ValueData         AS ValueData
           , OL_GoodsKindWeighing_Parent.ChildObjectId  AS ParentId
           , Object_Parent.ObjectCode               AS ParentCode
           , Object_Parent.ValueData                AS ParentName
           , Object_GoodsKindWeighing.AccessKeyId       AS AccessKeyId
           , OS_GoodsKindWeighing_NameFull.ValueData    AS NameFull
           , OS_GoodsKindWeighing_Name.ValueData        AS Name
           , OS_GoodsKindWeighing_NameUser.ValueData    AS NameUser
           , Object_GoodsKindWeighing.isErased          AS isErased
           , ObjectBoolean_isLeaf.ValueData         AS isLeaf
       FROM Object AS Object_GoodsKindWeighing

           LEFT JOIN ObjectLink AS OL_GoodsKindWeighing_Parent
                                ON OL_GoodsKindWeighing_Parent.ObjectId = Object_GoodsKindWeighing.Id
                               AND OL_GoodsKindWeighing_Parent.DescId = zc_ObjectLink_GoodsKindWeighing_Parent()

           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = OL_GoodsKindWeighing_Parent.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_GoodsKindWeighing.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

           LEFT JOIN ObjectString AS OS_GoodsKindWeighing_NameFull
                                  ON OS_GoodsKindWeighing_NameFull.ObjectId = Object_GoodsKindWeighing.Id
                                 AND OS_GoodsKindWeighing_NameFull.DescId = zc_ObjectString_GoodsKindWeighing_NameFull()

           LEFT JOIN ObjectString AS OS_GoodsKindWeighing_Name
                                  ON OS_GoodsKindWeighing_Name.ObjectId = Object_GoodsKindWeighing.Id
                                 AND OS_GoodsKindWeighing_Name.DescId = zc_ObjectString_GoodsKindWeighing_Name()

           LEFT JOIN ObjectString AS OS_GoodsKindWeighing_NameUser
                                  ON OS_GoodsKindWeighing_NameUser.ObjectId = Object_GoodsKindWeighing.Id
                                 AND OS_GoodsKindWeighing_NameUser.DescId = zc_ObjectString_GoodsKindWeighing_NameUser()



       WHERE Object_GoodsKindWeighing.DescId = zc_Object_GoodsKindWeighing();

ALTER TABLE Object_GoodsKindWeighing_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.
 25.03.14                                                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_GoodsKindWeighing_View
