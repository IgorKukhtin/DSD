-- Function: gpGet_MI_Income_PartnerParam (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_MI_Income_PartnerParam (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Income_PartnerParam(
    IN inId        Integer  , -- ���� ���������
    IN inSession   TVarChar   -- ������ ������������
)
RETURNS TABLE (PricePartner TFloat, AmountPartnerSecond TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT COALESCE (MIFloat_PricePartner.ValueData, 0)       ::TFloat AS PricePartner
            , COALESCE (MIFloat_AmountPartnerSecond.ValueData,0) ::TFloat AS AmountPartnerSecond
       FROM MovementItem
           LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                       ON MIFloat_PricePartner.MovementItemId = inId
                                      AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()

           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                       ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
       WHERE MovementItem.Id = inId
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.10.24         *
*/

-- ����
--SELECT * FROM gpGet_MI_Income_PartnerParam (inId:= 304450541, inDescCode:= 'zc_MIFloat_PricePartner', inSession:= zfCalc_UserAdmin())