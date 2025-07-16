-- Function: gpSelect_MI_PromoTradeOkupaemost_Print()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeOkupaemost_Print (Integer, TFloat, Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoTradeOkupaemost_Print(
    IN inMovementId       Integer,       -- ���� ��������� 
    IN inPersentOnCredit  TFloat,        -- % �� �������, ���
    IN inNum1             Integer,       -- � ����� ������ ������� 1
    IN inNum2             Integer,       -- � ����� ������ ������� 2
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (TextInfo        TVarChar
             , RetailName      TVarChar   -- �������� ����      
             , PriceListName   TVarChar   --
             , ChangePercent         TFloat
             , Persent_Condition     TFloat 
             , Summ_pos_1          TFloat     --��������� ����� �������, ��� 
             , Summ_pos_2          TFloat     --��������� ����� �������, ��� 
             , Summ_one            TFloat
             , PartnerCount          TFloat
             , SummPromo_1         TFloat     --��������� �������������� ����� ������, ���
             , SummPromo_2         TFloat     --��������� �������������� ����� ������, ��� 
             , Due_Pass_year1      TFloat     --��������� ������1 � ���, ���
             , Due_Pass_year2      TFloat     --��������� ������2 � ���, ���
             , TotalCost_1         TFloat     --����� ������, ���
             , TotalCost_2         TFloat     --����� ������, ���
             , Profit1           TFloat     --�������1, ��� ���
             , Profit2           TFloat     --�������2, ��� ���
             , PaybackPeriod1    TFloat     --������ �����������1, ���.
             , PaybackPeriod2    TFloat     --������ �����������2, ���.
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH 
    --��������� ������
    tmpData AS (SELECT *
                FROM gpSelect_MI_PromoTradeOkupaemost(inMovementId, inPersentOnCredit, inSession) AS tmp
                WHERE tmp.Num IN (inNum1, inNum2)
                )
    --����� ����������� ��� ������
    SELECT CASE WHEN inNum1 = 1 THEN '������� ������������ �������' ELSE '����� ������������ �������' END ::TVarChar AS TextInfo
         , tmpData.RetailName
         , tmpData.PriceListName
         , CASE WHEN tmpData.Num IN (1,2) THEN tmpData.ChangePercent ELSE tmpData.ChangePercent_new END          ::TFloat AS ChangePercent
         , MAX (CASE WHEN tmpData.Num IN (1,2) THEN tmpData.Persent_Condition ELSE tmpData.Persent_Condition_new END)  ::TFloat AS Persent_Condition    --����. �������:
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Summ_pos ELSE 0 END)       ::TFloat AS Summ_pos_1
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Summ_pos ELSE 0 END)       ::TFloat AS Summ_pos_2
         , CASE WHEN SUM (COALESCE (tmpData.PartnerCount,0)) <> 0 THEN  SUM (tmpData.Summ) / SUM (tmpData.PartnerCount) ELSE 0 END ::TFloat AS Summ_one             --��������� ����� 1 SKU � 1��:
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN COALESCE (tmpData.PartnerCount,0) ELSE 0 END )                                 ::TFloat AS PartnerCount                                                                                                                   --���-�� ��
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.SummPromo * 12 ELSE 0 END) ::TFloat AS SummPromo_1                                    --����� "��������� �������������� ����� ������, ���" ������� "�����������" * 12
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.SummPromo * 12 ELSE 0 END) ::TFloat AS SummPromo_2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Due_Pass_year1 ELSE 0 END) ::TFloat AS Due_Pass_year1                                 --����� "��������� ������1 � ���, ���" ������� "�����������"
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Due_Pass_year2 ELSE 0 END) ::TFloat AS Due_Pass_year2
       
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.TotalCost ELSE 0 END)      ::TFloat AS TotalCost_1                                    --����� ������, ���
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.TotalCost ELSE 0 END)      ::TFloat AS TotalCost_2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.Profit1 ELSE 0 END)        ::TFloat AS Profit1                                        --�������, ��� ���
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.Profit2 ELSE 0 END)        ::TFloat AS Profit2
         , SUM (CASE WHEN tmpData.Num IN (1,3) THEN tmpData.PaybackPeriod1 ELSE 0 END) ::TFloat AS PaybackPeriod1                                 --�������� ����������� �� ����, ���
         , SUM (CASE WHEN tmpData.Num IN (2,4) THEN tmpData.PaybackPeriod2 ELSE 0 END) ::TFloat AS PaybackPeriod2
    FROM tmpData
    GROUP BY tmpData.RetailName
        , tmpData.PriceListName
        , CASE WHEN tmpData.Num IN (1,2) THEN tmpData.ChangePercent ELSE tmpData.ChangePercent_new END
        --, CASE WHEN tmpData.Num IN (1,2) THEN tmpData.Persent_Condition ELSE tmpData.Persent_Condition_new END
        --, CASE WHEN COALESCE (tmpData.PartnerCount,0) <> 0 THEN  tmpData.Summ / tmpData.PartnerCount ELSE 0 END
        --, tmpData.PartnerCount  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.07.25         *
*/
-- ����
-- select * from gpSelect_MI_PromoTradeOkupaemost_Print(inMovementId := 31603021, inPersentOnCredit:=18.5, inNum1:=1, inNum2:=2, inSession := '9457');
--            select * from gpSelect_MI_PromoTradeOkupaemost_Print(inMovementId := 31603021 , inPersentOnCredit := 18.5 , inNum1 := 1 , inNum2 := 2 ,  inSession := '9457');--