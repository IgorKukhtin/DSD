-- Function: gpGet_MI_ParamFloat (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_MI_ParamFloat (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_ParamFloat(
    IN inId        Integer  , -- ���� ���������
    IN inDescCode  TVarChar , -- 
    IN inSession   TVarChar   -- ������ ������������
)
RETURNS TABLE (Value TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT COALESCE (MovementItemFloat.ValueData, 0)  ::TFloat AS Value
       FROM MovementItemFloatDesc
             INNER JOIN MovementItemFloat ON MovementItemFloat.DescId = MovementItemFloatDesc.Id
                                         AND MovementItemFloat.MovementItemId = inId
       WHERE MovementItemFloatDesc.Code = inDescCode
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.24         * CurrencyUser
*/

-- ����
--SELECT * FROM gpGet_MI_ParamFloat (inId:= 304450541, inDescCode:= 'zc_MIFloat_PricePartner', inSession:= zfCalc_UserAdmin())