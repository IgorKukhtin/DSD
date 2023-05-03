-- Function: gpGet_Object_DiscountExternal_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternal_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternal_Unit(
    IN inId          Integer,       -- ���� ������� <����������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL                TVarChar
             , Service            TVarChar
             , Port               TVarChar
             , UserName           TVarChar
             , Password           TVarChar
             , ExternalUnit       TVarChar
             , Token              TVarChar
             , isOneSupplier      Boolean 
             , isTwoPackages      Boolean
              )
AS
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

       -- ���������
       RETURN QUERY
       SELECT
             Object_DiscountExternal.Id         AS Id
           , Object_DiscountExternal.ObjectCode AS Code
           , Object_DiscountExternal.ValueData  AS Name

           , ObjectString_URL.ValueData       AS URL
           , ObjectString_Service.ValueData   AS Service
           , ObjectString_Port.ValueData      AS Port

           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_User.ValueData END::TVarChar           AS UserName
           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_Password.ValueData END::TVarChar       AS Password
           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_ExternalUnit.ValueData END::TVarChar   AS ExternalUnit
           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_Token.ValueData END::TVarChar          AS Token
           , COALESCE(ObjectBoolean_OneSupplier.ValueData, False)      AS isOneSupplier
           , COALESCE(ObjectBoolean_TwoPackages.ValueData, False)      AS isTwoPackages

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
            INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ChildObjectId = Object_DiscountExternal.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
            INNER JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId      = ObjectLink_DiscountExternal.ObjectId
                                 AND ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountExternalTools_Unit()
                                 AND ObjectLink_Unit.ChildObjectId = vbUnitId

            LEFT JOIN ObjectString AS ObjectString_User
                                   ON ObjectString_User.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
            LEFT JOIN ObjectString AS ObjectString_Password
                                   ON ObjectString_Password.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()
            LEFT JOIN ObjectString AS ObjectString_ExternalUnit
                                   ON ObjectString_ExternalUnit.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_ExternalUnit.DescId = zc_ObjectString_DiscountExternalTools_ExternalUnit()
            LEFT JOIN ObjectString AS ObjectString_Token
                                   ON ObjectString_Token.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_Token.DescId = zc_ObjectString_DiscountExternalTools_Token()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotUseAPI
                                    ON ObjectBoolean_NotUseAPI.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                   AND ObjectBoolean_NotUseAPI.DescId = zc_ObjectBoolean_DiscountExternalTools_NotUseAPI()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_OneSupplier
                                    ON ObjectBoolean_OneSupplier.ObjectId = Object_DiscountExternal.Id
                                   AND ObjectBoolean_OneSupplier.DescId = zc_ObjectBoolean_DiscountExternal_OneSupplier()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_TwoPackages
                                    ON ObjectBoolean_TwoPackages.ObjectId = Object_DiscountExternal.Id
                                   AND ObjectBoolean_TwoPackages.DescId = zc_ObjectBoolean_DiscountExternal_TwoPackages()
       WHERE Object_DiscountExternal.Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternal_Unit (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.  ������ �.�.
 12.03.21                                                                     *
 29.05.17                                                       * ExternalUnit
 12.08.16                                        *
*/

-- ����
-- 
select * from gpGet_Object_DiscountExternal_Unit(inId := 22264564 ,  inSession := '3');