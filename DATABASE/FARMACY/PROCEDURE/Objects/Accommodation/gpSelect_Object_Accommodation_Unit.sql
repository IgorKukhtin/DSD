-- Function: gpSelect_Object_Accommodation_Unit(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Accommodation_Unit (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Accommodation_Unit(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- ���������
    RETURN QUERY 
       SELECT
              Object_Accommodation.Id                       AS GoodsID 
            , Object_Accommodation.ObjectCode               AS AccommodationID
            , Object_Accommodation.ValueData                AS AccommodationName
            , Object_Accommodation.isErased                 AS isErased
       FROM Object AS Object_Accommodation

           INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                 ON ObjectLink_Accommodation_Unit.ChildObjectId = vbUnitId
                                AND ObjectLink_Accommodation_Unit.ObjectId = Object_Accommodation.Id
                                AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

       WHERE Object_Accommodation.DescId = zc_Object_Accommodation()
         AND (Object_Accommodation.isErased = False OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_Accommodation_Unit (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 17.08.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Accommodation_Unit (zfCalc_UserAdmin()) ORDER BY Code