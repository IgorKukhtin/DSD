--- Function: gpSelect_MovementItem_LoyaltySaveMoneyInfo()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltySaveMoneyInfo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltySaveMoneyInfo(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Name TVarChar
             , Value TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        WITH
        tmpMI AS (SELECT MI_Master.Id
                       , MI_Master.IsErased

                  FROM MovementItem AS MI_Master
                  WHERE MI_Master.MovementId = inMovementId
                    AND MI_Master.DescId = zc_MI_Master()
                  )
       SELECT  1 as Id, '���������� �����������'::TVarChar AS Name, (SELECT COUNT(*) FROM tmpMI)::TFloat AS Value
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.19                                                       *
*/

-- select * from gpSelect_MovementItem_LoyaltySaveMoneyInfo(inMovementId := 2,  inSession := '3'::TVarChar);