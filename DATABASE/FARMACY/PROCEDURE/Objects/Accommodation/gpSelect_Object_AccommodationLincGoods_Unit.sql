-- Function: gpSelect_Object_AccommodationLincGoods_Unit(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AccommodationLincGoods_Unit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccommodationLincGoods_Unit(
    IN inUnitId      Integer,
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (UnitID Integer
             , UnitCode Integer
             , UnitName TVarChar
             , GoodsID Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , AccommodationID Integer
             , AccommodationCode Integer
             , AccommodationName TVarChar
             , UserID Integer
             , UserName TVarChar
             , DateUpdate TDateTime
             , isErased Boolean
              )
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
              Object_Unit.Id                                  AS UnitID
            , Object_Unit.ObjectCode                          AS UnitCode
            , Object_Unit.ValueData                           AS UnitName
            , Object_Goods.Id                                 AS GoodsID
            , Object_Goods.ObjectCode                         AS GoodsCode
            , Object_Goods.ValueData                          AS GoodsName
            , Object_Accommodation.Id                         AS AccommodationID
            , Object_Accommodation.ObjectCode                 AS AccommodationCode
            , Object_Accommodation.ValueData                  AS AccommodationName
            , Object_User.ID                                  AS UserID
            , Object_User.ValueData                           AS UserName
            , AccommodationLincGoods.DateUpdate               AS DateUpdate
            , AccommodationLincGoods.isErased                 AS isErased
       FROM AccommodationLincGoods
       
            INNER JOIN Object AS Object_Accommodation ON Object_Accommodation.ID = AccommodationLincGoods.AccommodationId

            INNER JOIN Object AS Object_Goods ON Object_Goods.ID = AccommodationLincGoods.GoodsId

            INNER JOIN Object AS Object_Unit ON Object_Unit.ID = AccommodationLincGoods.UnitId

            LEFT JOIN Object AS Object_User ON Object_User.ID = AccommodationLincGoods.UserUpdateId
            
       WHERE (Object_Unit.Id = inUnitId OR COALESCE(inUnitId, 0) = 0)
         AND (COALESCE (inIsShowAll, False) = True OR AccommodationLincGoods.isErased = False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_AccommodationLincGoods_Unit (Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 19.04.21                                                      * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_AccommodationLincGoods_Unit (0, False, zfCalc_UserAdmin())