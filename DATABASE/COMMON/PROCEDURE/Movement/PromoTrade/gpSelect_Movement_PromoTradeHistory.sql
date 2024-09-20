
-- Function: gpSelect_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTradeHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTradeHistory(
    IN inMovementId    Integer , -- ���� ��������� <�����>
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Ord              Integer
             , Name             TVarChar    --��� ���������
             , Value            TVarChar    --�������� ��������� 
              )

AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeHistory Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

 /* 
  select sum(zc_MI_Master.zc_MIFloat_AmountSale)
  union select sum(zc_MI_Master.zc_MIFloat_AmountReturnIn) 
  union select % ��������- ������ 
  union select zc_MovementFloat_DebtDay 
  union select zc_MovementFloat_DebtSumm    
 */

    vbMovementId_PromoTradeHistory := (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.DescId = zc_Movement_PromoTradeHistory()
                                         AND Movement.ParentId =  inMovementId
                                       );


    -- ���������
    RETURN QUERY
    WITH 
    tmpText AS (    SELECT  1 ::Integer  AS Ord, '�������������� �������, ��:'                    ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, '�������������� �������, ���:'                   ::TVarChar AS Name   --
              UNION SELECT  3 ::Integer  AS Ord, '% ��������:'                                    ::TVarChar AS Name
              UNION SELECT  4 ::Integer  AS Ord, '������������ ����������� �������������, ���:'   ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord, '������������ ����������� �������������, ����:'  ::TVarChar AS Name
                 )
  , tmpMI_Master AS (SELECT SUM (COALESCE (MIFloat_AmountSale.ValueData,0))     AS AmountSale
                          , SUM (COALESCE (MIFloat_AmountReturnIn.ValueData,0)) AS AmountReturnIn
                          , SUM (COALESCE (MIFloat_SummSale.ValueData,0))       AS SummSale
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountSale
                                                      ON MIFloat_AmountSale.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountSale.DescId = zc_MIFloat_AmountSale()
                          LEFT JOIN MovementItemFloat AS MIFloat_SummSale
                                                      ON MIFloat_SummSale.MovementItemId = MovementItem.Id
                                                     AND MIFloat_SummSale.DescId = zc_MIFloat_SummSale()                
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountReturnIn
                                                      ON MIFloat_AmountReturnIn.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountReturnIn.DescId = zc_MIFloat_AmountReturnIn()                          
                     WHERE MovementItem. MovementId = inMovementId
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
                     )

    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , CAST (tmpMI_Master.AmountSale/3 AS NUMERIC (16,3)) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpMI_Master ON 1=1
    WHERE tmpText.Ord = 1
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , CAST (tmpMI_Master.SummSale/3 AS NUMERIC (16,2)) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpMI_Master ON 1=1
    WHERE tmpText.Ord = 2
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , CAST (CASE WHEN COALESCE (tmpMI_Master.AmountSale,0) <> 0 THEN tmpMI_Master.AmountReturnIn * 100 / tmpMI_Master.AmountSale ELSE 0 END AS NUMERIC (16,1)) ::TVarChar AS Value                                               
    FROM tmpText
         LEFT JOIN tmpMI_Master ON 1=1
    WHERE tmpText.Ord = 3
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , CAST (MovementFloat_DebtDay.ValueData AS NUMERIC (16,2)) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DebtDay 
                                 ON MovementFloat_DebtDay.MovementId = vbMovementId_PromoTradeHistory
                                AND MovementFloat_DebtDay.DescId = zc_MovementFloat_DebtDay()
    WHERE tmpText.Ord = 4
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , CAST (MovementFloat_DebtSumm.ValueData AS NUMERIC (16,2)) ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DebtSumm 
                                 ON MovementFloat_DebtSumm.MovementId = vbMovementId_PromoTradeHistory
                                AND MovementFloat_DebtSumm.DescId = zc_MovementFloat_DebtSumm()
    WHERE tmpText.Ord = 5
    
    ORDER by 1  
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.09.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTradeHistory (inMovementId:= 29197668 , inSession:= zfCalc_UserAdmin())
