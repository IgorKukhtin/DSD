-- Function: gpReport_Sale_Analysis()

DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_Analysis (
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- �������������
    IN inPartnerId        Integer  ,  -- ���������
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inLineFabricaId    Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inPresent1         TFloat   ,
    IN inPresent2         TFloat   ,
    IN inPresent1_Summ    TFloat   ,
    IN inPresent2_Summ    TFloat   ,
    IN inPresent1_Prof    TFloat   ,
    IN inPresent2_Prof    TFloat   ,
    IN inIsPeriodAll      Boolean  , -- ����������� �� ���� ������ (��/���) (�������� �� ����������)
    IN inIsUnit           Boolean  , -- �� ��������� ��������������
    IN inIsBrand          Boolean  , -- �� ��������� � ������� ������
    IN inIsAmount         Boolean  , -- ������������ �� ������ �� % ������ ���-��
    IN inIsSumm           Boolean  , -- ������������ �� ������ �� % ������ �����
    IN inIsProf           Boolean  , -- ������������ �� ������ �� % �������
    IN inIsLineFabrica    Boolean  , -- �������� ����� ��/���
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE Cursor1       refcursor;
   DECLARE Cursor2       refcursor;
   DECLARE Cursor3       refcursor;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ������ ���� ������� ���� �� �������������
    IF (COALESCE (inIsAmount, FALSE) = TRUE AND COALESCE (inIsSumm, FALSE) = TRUE)
    OR (COALESCE (inIsAmount, FALSE) = TRUE AND COALESCE (inIsProf, FALSE) = TRUE)
    OR (COALESCE (inIsSumm, FALSE) = TRUE   AND COALESCE (inIsProf, FALSE) = TRUE)
    THEN
        RAISE EXCEPTION '������. ������ ���� ������ ������ ���� ������ �������������';
    END IF;
    
CREATE TEMP TABLE _tmpData ( BrandName             TVarChar      
                           , PeriodName            TVarChar      
                           , PeriodYear            Integer       
                           , PartnerId             Integer       
                           , PartnerName           TVarChar      
                           , LineFabricaName       TVarChar      
                                                                 
                           , UnitName              TVarChar      
                           , UnitName_In           TVarChar      
                           , CurrencyName          TVarChar      
                                                                 
                           , Income_Amount         TFloat        
                           , Income_Summ           TFloat        
                                                                 
                           , Debt_Amount           TFloat        
                           , Sale_Amount           TFloat        
                           , Sale_Summ             TFloat        
                           , Sale_Summ_curr        TFloat        
                           , Sale_SummCost         TFloat        
                           , Sale_SummCost_curr    TFloat        
                           , Sale_SummCost_diff    TFloat        
                           , Sale_Summ_prof        TFloat        
                           , Sale_Summ_prof_curr   TFloat        
                           , Sale_Summ_10100       TFloat        
                           , Sale_Summ_10201       TFloat        
                           , Sale_Summ_10202       TFloat        
                           , Sale_Summ_10203       TFloat        
                           , Sale_Summ_10204       TFloat        
                           , Sale_Summ_10200       TFloat        
                           , Sale_Summ_10200_curr  TFloat        
                           , Sale_Summ_10201_curr  TFloat        
                           , Sale_Summ_10202_curr  TFloat        
                           , Sale_Summ_10203_curr  TFloat        
                           , Sale_Summ_10204_curr  TFloat        
                           , Tax_Amount            TFloat                         
                           , Tax_Summ_curr         TFloat        
                           , Tax_Summ_prof         TFloat        
                           , Tax_Summ_10200        TFloat        
                           , Tax_Summ_10100        TFloat        
                           , Tax_Summ_10203        TFloat        
                           , Tax_Summ_10201        TFloat        
                           , Tax_Summ_10202        TFloat        
                           , Sale_Amount_10202        TFloat            
                           , Sale_Amount_InDiscount   TFloat                             
                           , Sale_Amount_OutDiscount  TFloat     
                           , Tax_Amount_10202  TFloat            
                           , Tax_InDiscount    TFloat            
                           , Tax_OutDiscount   TFloat            
                           , Color_Amount   Integer              
                           , Color_Sum      Integer              
                           , Color_Prof     Integer                             
                         ) ON COMMIT DROP;                                         
                                                                                   
        INSERT INTO _tmpData (BrandName
                            , PeriodName
                            , PeriodYear
                            , PartnerId
                            , PartnerName
                            , LineFabricaName
                           
                            , UnitName
                            , UnitName_In
                            , CurrencyName

                            , Income_Amount
                            , Income_Summ
                            , Debt_Amount
                            , Sale_Amount
                            , Sale_Summ
                            , Sale_Summ_curr
                            , Sale_SummCost
                            , Sale_SummCost_curr
                            , Sale_SummCost_diff
                            , Sale_Summ_prof
                            , Sale_Summ_prof_curr
                            , Sale_Summ_10100
                            , Sale_Summ_10201
                            , Sale_Summ_10202
                            , Sale_Summ_10203
                            , Sale_Summ_10204
                            , Sale_Summ_10200
                            , Sale_Summ_10200_curr
                            , Sale_Summ_10201_curr
                            , Sale_Summ_10202_curr
                            , Sale_Summ_10203_curr
                            , Sale_Summ_10204_curr
             
                            , Tax_Amount
                            , Tax_Summ_curr
                            , Tax_Summ_prof
                            , Tax_Summ_10200 
                            , Tax_Summ_10100
                            , Tax_Summ_10203
                            , Tax_Summ_10201 
                            , Tax_Summ_10202

                            , Sale_Amount_10202
                            , Sale_Amount_InDiscount
                            , Sale_Amount_OutDiscount
                            , Tax_Amount_10202
                            , Tax_InDiscount
                            , Tax_OutDiscount
                            
                            , Color_Amount
                            , Color_Sum
                            , Color_Prof
                              )
       
          SELECT  tt.BrandName               
               , tt.PeriodName              
               , tt.PeriodYear              
               , tt.PartnerId               
               , tt.PartnerName             
               , tt.LineFabricaName         
                                         
               , tt.UnitName                
               , tt.UnitName_In             
               , tt.CurrencyName            
                                         
               , tt.Income_Amount           
               , tt.Income_Summ             
               , tt.Debt_Amount             
               , tt.Sale_Amount             
               , tt.Sale_Summ               
               , tt.Sale_Summ_curr          
               , tt.Sale_SummCost           
               , tt.Sale_SummCost_curr      
               , tt.Sale_SummCost_diff      
               , tt.Sale_Summ_prof          
               , tt.Sale_Summ_prof_curr     
               , tt.Sale_Summ_10100         
               , tt.Sale_Summ_10201         
               , tt.Sale_Summ_10202         
               , tt.Sale_Summ_10203         
               , tt.Sale_Summ_10204         
               , tt.Sale_Summ_10200         
               , tt.Sale_Summ_10200_curr    
               , tt.Sale_Summ_10201_curr    
               , tt.Sale_Summ_10202_curr    
               , tt.Sale_Summ_10203_curr    
               , tt.Sale_Summ_10204_curr    
                                         
               , tt.Tax_Amount              
               , tt.Tax_Summ_curr           
               , tt.Tax_Summ_prof           
               , tt.Tax_Summ_10200          
               , tt.Tax_Summ_10100          
               , tt.Tax_Summ_10203          
               , tt.Tax_Summ_10201          
               , tt.Tax_Summ_10202          
                                         
               , tt.Sale_Amount_10202       
               , tt.Sale_Amount_InDiscount  
               , tt.Sale_Amount_OutDiscount 
               , tt.Tax_Amount_10202        
               , tt.Tax_InDiscount          
               , tt.Tax_OutDiscount         
                                         
               , tt.Color_Amount            
               , tt.Color_Sum               
               , tt.Color_Prof              
        
        FROM gpReport_Sale_AnalysisAll(inStartDate     ,
                                       inEndDate       ,
                                       inUnitId        ,
                                       inPartnerId     ,
                                       inBrandId       ,
                                       inPeriodId      ,
                                       inLineFabricaId ,
                                       inStartYear     ,
                                       inEndYear       ,
                                       inPresent1      ,
                                       inPresent2      ,
                                       inPresent1_Summ ,
                                       inPresent2_Summ ,
                                       inPresent1_Prof ,
                                       inPresent2_Prof ,
                                       inIsPeriodAll   ,
                                       inIsUnit        ,
                                       inIsBrand       ,
                                       inIsAmount      ,
                                       inIsSumm        ,
                                       inIsProf        ,
                                       inIsLineFabrica ,
                                       inSession       ) as tt;

                                  
     OPEN Cursor1 FOR
     SELECT * 
     FROM _tmpData
     WHERE (inIsAmount = TRUE AND _tmpData.Tax_Amount     >= inPresent1)
        OR (inIsSumm   = TRUE AND _tmpData.Tax_Summ_curr >= inPresent1_Summ)
        OR (inIsProf   = TRUE AND _tmpData.Tax_Summ_prof  >= inPresent1_Prof)
  ;
  RETURN NEXT Cursor1;

     --������� ������ 20% ������ 50% �� �������
     OPEN Cursor2 FOR
     SELECT * 
     FROM _tmpData
     WHERE (inIsAmount = TRUE AND _tmpData.Tax_Amount    >= inPresent2      AND Tax_Amount    < inPresent1)
        OR (inIsSumm   = TRUE AND _tmpData.Tax_Summ_curr >= inPresent2_Summ AND Tax_Summ_curr < inPresent1_Summ)
        OR (inIsProf   = TRUE AND _tmpData.Tax_Summ_prof >= inPresent2_Prof AND Tax_Summ_prof < inPresent1_Prof)
     ;
     RETURN NEXT Cursor2; 

     --������� ������ 20% �� �������
     OPEN Cursor3 FOR
     SELECT * 
     FROM _tmpData
     WHERE (inIsAmount = TRUE AND _tmpData.Tax_Amount    < inPresent2)
        OR (inIsSumm   = TRUE AND _tmpData.Tax_Summ_curr < inPresent2_Summ)
        OR (inIsProf   = TRUE AND _tmpData.Tax_Summ_prof < inPresent2_Prof)
     ;
     RETURN NEXT Cursor3;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.18         *
 09.11.18         *
 26.07.18         *
*/

-- ����
-- select * from gpReport_Sale_Analysis(inStartDate := ('01.01.2018')::TDateTime , inEndDate := ('31.01.2018')::TDateTime , inUnitId := 1530 , inPartnerId := 0 , inBrandId := 0 , inPeriodId := 1554 , inLineFabricaId := 0 , inStartYear := 2001 , inEndYear := 2008 , inPresent1 := 80 , inPresent2 := 50 , inPresent1_Summ := 125 , inPresent2_Summ := 80 , inPresent1_Prof := 80 , inPresent2_Prof := 50 , inIsPeriodAll := 'True' , inIsUnit := 'False' , inIsBrand := 'False' , inIsAmount := 'True' , inIsSumm := 'False' , inIsProf := 'False' , inIsLineFabrica := 'False' ,  inSession := '8');