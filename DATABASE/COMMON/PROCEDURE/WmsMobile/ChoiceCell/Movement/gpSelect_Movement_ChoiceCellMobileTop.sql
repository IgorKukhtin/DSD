-- Function: gpSelect_Movement_ChoiceCellMobileTop()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceCellMobileTop (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceCellMobileTop(
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementItemId Integer
             , ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar, ChoiceCellName_search TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean, ErasedCode Integer
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �����
     RETURN QUERY
       SELECT *
       FROM gpSelect_Movement_ChoiceCellMobile (inIsOrderBy := False, inIsAllUser := False, inIsErased := False, inLimit := 10, inFilter := '', inSession := inSession) AS tmpMI
       WHERE tmpMI.InsertDate >= CURRENT_DATE - INTERVAL '1 DAY'
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.24                                                       *
*/

-- ����
--
-- SELECT * FROM gpSelect_Movement_ChoiceCellMobileTop (inSession := zfCalc_UserAdmin());
