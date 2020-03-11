DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_ActionCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_ActionCheck(
    IN inMovementId          Integer   , -- 
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Text
AS
$BODY$
   DECLARE vbRetailId         Integer;
   DECLARE vbMessageText      Text; 
BEGIN
     
     vbMessageText := '';
                 
     -- ���������� �� ������� ���� ������� ����� 1,5 ���
     vbMessageText := (SELECT STRING_AGG ('(' || tmp.GoodsCode ||') '||tmp.GoodsName, '; ' ORDER BY tmp.GoodsName)
                       FROM gpSelect_MovementItem_Income (inMovementId := inMovementId  , inShowAll := FALSE , inIsErased := FALSE ,  inSession := inSession) as tmp
                       WHERE tmp.Price <= 1.5
                       ) :: Text;

     IF COALESCE (vbMessageText, '') <> ''
     THEN 
         outMessageText :=  outMessageText ||' ��������!!! � ��������� ��������� ���� ������ � ����� ��� ��� ������ ��� 1,5���. ��������� - �������� �� ���� �����  ��������� !!! '||vbMessageText;
     END IF;   
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.18         *
*/
-- select * from gpSelect_MovementItem_Income_LinkCheck (inMovementId := 11459485  ,  inSession := '3');  
-- vbJuridicalId = 183312