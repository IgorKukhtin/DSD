-- Function: gpSelect_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternal(
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL TVarChar
             , Service TVarChar
             , Port TVarChar
             , isErased Boolean
              ) AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());
     vbUserId := lpGetUserBySession (inSession);

     vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey :: Integer;


   RETURN QUERY 
   SELECT Object_DiscountExternal.Id             AS Id
        , Object_DiscountExternal.ObjectCode     AS Code
        , Object_DiscountExternal.ValueData      AS Name

        , ObjectString_URL.ValueData       AS URL
        , ObjectString_Service.ValueData   AS Service
        , ObjectString_Port.ValueData      AS Port

        , Object_DiscountExternal.isErased

   FROM Object AS Object_DiscountExternal
      LEFT JOIN ObjectString AS ObjectString_URL
                             ON ObjectString_URL.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_URL.DescId = zc_ObjectString_DiscountExternal_URL()
      LEFT JOIN ObjectString AS ObjectString_Service
                             ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()
      LEFT JOIN ObjectString AS ObjectString_Port
                             ON ObjectString_Port.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Port.DescId = zc_ObjectString_DiscountExternal_Port()
   WHERE Object_DiscountExternal.DescId = zc_Object_DiscountExternal()
     AND (vbUnitId = 0
       OR COALESCE (ObjectString_URL.ValueData, '') = ''
       OR Object_DiscountExternal.Id IN (SELECT ObjectLink_DiscountExternal.ChildObjectId
                                         FROM ObjectLink AS ObjectLink_Unit
                                              INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                                    ON ObjectLink_DiscountExternal.ObjectId = ObjectLink_Unit.ObjectId
                                                                   AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                         WHERE ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountExternalTools_Unit()
                                           AND ObjectLink_Unit.ChildObjectId = vbUnitId
                                        )
         );
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_DiscountExternal ('2')
