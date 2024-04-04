-- Function: gpSelect_MovementItem_MobileInventoryTop()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileInventoryTop (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileInventoryTop(
    IN inMovementId       Integer      , -- ���� ���������
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, LocalId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar, PartNumber TVarChar
             , PartionCellId Integer, PartionCellName TVarChar
             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat, AmountDiff TFloat, AmountRemains_curr TFloat
             , OrdUser Integer, OperDate_protocol TDateTime, UserName_protocol TVarChar
             , isErased Boolean, Error TVarChar
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �����
     RETURN QUERY
       SELECT
             tmpMI.Id
           , 0                                   AS LocalId  
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.Article 
           , tmpMI.EAN
           , tmpMI.GoodsGroupId
           , tmpMI.GoodsGroupName
           , tmpMI.MeasureName
           , tmpMI.PartNumber                    AS PartNumber
           
           , tmpMI.PartionCellId                 AS PartionCellId
           , tmpMI.PartionCellName

           , tmpMI.Amount                        AS Amount
           , tmpMI.TotalCount
           , tmpMI.AmountRemains
           , tmpMI.AmountDiff

           , tmpMI.AmountRemains_curr

           , tmpMI.OrdUser
           , tmpMI.OperDate_protocol
           , tmpMI.UserName_protocol
           , tmpMI.isErased
           , ''::TVarChar                        AS Error

       FROM gpSelect_MovementItem_MobileInventory (inMovementId := inMovementId, inIsOrderBy := False, inIsAllUser := False, inIsErased := False, inLimit := 3, inFilter := '', inSession := inSession) AS tmpMI;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.04.24                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_MovementItem_MobileInventoryTop (inMovementId := 3183, inSession := zfCalc_UserAdmin());