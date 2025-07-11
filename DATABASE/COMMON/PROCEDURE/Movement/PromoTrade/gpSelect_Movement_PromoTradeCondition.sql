-- Function: gpSelect_Movement_PromoTradeCondition()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTradeCondition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTradeCondition(
    IN inMovementId    Integer , -- ���� ��������� <�����>
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Ord              Integer
             , Name             TVarChar    --��� ���������
             , Value            TVarChar    --�������� ���������
             , Value_new        TVarChar    --����� ��������
              )

AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeCondition Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

 /*     select zc_MovementLinkObject_PriceList 
 union select zc_MovementLinkObject_Contract.������ 
 union select zc_MovementLinkObject_Contract.�������� �� �������� (� ���� ������� �������� ���� ��� ����������� ���)   zc_MovementLinkObject_ContractConditionKind /  zc_MovementFloat_DelayDay
 union select zc_MovementFloat_RetroBonus :: TVarChar 
 union select zc_MovementFloat_Market :: TVarChar 
 union select zc_MovementFloat_ReturnIn :: TVarChar 
 union select zc_MovementFloat_Logist :: TVarChar
 */

    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    -- ���������
    RETURN QUERY
    WITH 
    tmpText AS (    SELECT  1 ::Integer  AS Ord, '�����-����:'              ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, '������:'                  ::TVarChar AS Name
              UNION SELECT  3 ::Integer  AS Ord, '�������� �� ��������:'    ::TVarChar AS Name
              UNION SELECT  4 ::Integer  AS Ord, '����� �����:'             ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord  , '������������� ������:'  ::TVarChar AS Name
              UNION SELECT  6 ::Integer  AS Ord  , '����������� ���������:' ::TVarChar AS Name
              UNION SELECT  7 ::Integer  AS Ord  , '������������� �����:'   ::TVarChar AS Name
              UNION SELECT  8 ::Integer  AS Ord  , '������:'                ::TVarChar AS Name
              UNION SELECT  9 ::Integer  AS Ord  , '��������� (���), ���:'  ::TVarChar AS Name
             )

    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , Object_PriceList.ValueData ::TVarChar AS Value
          , Object_PriceList.ValueData ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList 
                                      ON MovementLinkObject_PriceList.MovementId = inMovementId
                                     AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
    WHERE tmpText.Ord = 1
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , MovementFloat_ChangePercent.ValueData     ::TVarChar AS Value
          , MovementFloat_ChangePercent_new.ValueData ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent 
                                 ON MovementFloat_ChangePercent.MovementId = inMovementId
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent_new 
                                 ON MovementFloat_ChangePercent_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_ChangePercent_new.DescId = zc_MovementFloat_ChangePercent_new()
    WHERE tmpText.Ord = 2
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , ((COALESCE (MovementFloat_DelayDay.ValueData, 0) ::Integer) ||     
            CASE WHEN MovementLinkObject_CCKind.ObjectId = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN ' �.��.'   
                 WHEN MovementLinkObject_CCKind.ObjectId = zc_Enum_ContractConditionKind_DelayDayBank() THEN ' �.��.'
                 ELSE ' ��.'
            END)                       ::TVarChar AS Value
          , ''                         ::TVarChar AS Value_new                                               
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DelayDay
                                 ON MovementFloat_DelayDay.MovementId = inMovementId
                                AND MovementFloat_DelayDay.DescId = zc_MovementFloat_DelayDay() 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_CCKind
                                      ON MovementLinkObject_CCKind.MovementId = inMovementId
                                     AND MovementLinkObject_CCKind.DescId = zc_MovementLinkObject_ContractConditionKind()
    WHERE tmpText.Ord = 3
     
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_RetroBonus.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_RetroBonus_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_RetroBonus 
                                 ON MovementFloat_RetroBonus.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_RetroBonus.DescId = zc_MovementFloat_RetroBonus()
         LEFT JOIN MovementFloat AS MovementFloat_RetroBonus_new 
                                 ON MovementFloat_RetroBonus_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_RetroBonus_new.DescId = zc_MovementFloat_RetroBonus_new()
    WHERE tmpText.Ord = 4
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Market.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_Market_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Market 
                                 ON MovementFloat_Market.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Market.DescId = zc_MovementFloat_Market()
         LEFT JOIN MovementFloat AS MovementFloat_Market_new 
                                 ON MovementFloat_Market_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Market_new.DescId = zc_MovementFloat_Market_new()
    WHERE tmpText.Ord = 5
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_ReturnIn.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_ReturnIn_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_ReturnIn
                                 ON MovementFloat_ReturnIn.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_ReturnIn.DescId = zc_MovementFloat_ReturnIn()
         LEFT JOIN MovementFloat AS MovementFloat_ReturnIn_new
                                 ON MovementFloat_ReturnIn_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_ReturnIn_new.DescId = zc_MovementFloat_ReturnIn_new()
    WHERE tmpText.Ord = 6
     
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Logist.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_Logist_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Logist
                                 ON MovementFloat_Logist.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Logist.DescId = zc_MovementFloat_Logist()
         LEFT JOIN MovementFloat AS MovementFloat_Logist_new
                                 ON MovementFloat_Logist_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Logist_new.DescId = zc_MovementFloat_Logist_new()
    WHERE tmpText.Ord = 7
    
 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_Report.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_Report_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_Report
                                 ON MovementFloat_Report.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Report.DescId = zc_MovementFloat_Report()
         LEFT JOIN MovementFloat AS MovementFloat_Report_new
                                 ON MovementFloat_Report_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_Report_new.DescId = zc_MovementFloat_Report_new()
    WHERE tmpText.Ord = 8     

 UNION
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , zfConvert_FloatToString (MovementFloat_MarketSumm.ValueData)     ::TVarChar AS Value
          , zfConvert_FloatToString (MovementFloat_MarketSumm_new.ValueData) ::TVarChar AS Value_new
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_MarketSumm
                                 ON MovementFloat_MarketSumm.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_MarketSumm.DescId = zc_MovementFloat_MarketSumm()
         LEFT JOIN MovementFloat AS MovementFloat_MarketSumm_new
                                 ON MovementFloat_MarketSumm_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_MarketSumm_new.DescId = zc_MovementFloat_MarketSumm_new()
    WHERE tmpText.Ord = 9
 ORDER by 1  
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.06.25         *
 16.09.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTradeCondition (inMovementId:= 29197668 , inSession:= zfCalc_UserAdmin())