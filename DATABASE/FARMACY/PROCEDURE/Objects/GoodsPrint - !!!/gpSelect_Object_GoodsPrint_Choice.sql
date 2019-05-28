-- Function: gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint_Choice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint_Choice(
    IN inUnitId      Integer,       --  
    IN inSession     TVarChar       --  ������ ������������
)
RETURNS TABLE (UnitId    Integer
             , GoodsId     Integer
             --, InsertDate TDateTime
 )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       SELECT DISTINCT
              Object_GoodsPrint.UnitId      AS UnitId
            , Object_GoodsPrint.GoodsId     AS GoodsId
            --, Object_GoodsPrint.InsertDate  AS InsertDate
       FROM Object_GoodsPrint
       WHERE Object_GoodsPrint.UserId = inUserId
         AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId  = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
28.05.19          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsPrint_Choice (0, zfCalc_UserAdmin())
