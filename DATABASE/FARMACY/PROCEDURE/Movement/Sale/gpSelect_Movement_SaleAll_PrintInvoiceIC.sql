-- Function: gpSelect_Movement_SaleAll_PrintInvoiceIC()

DROP FUNCTION IF EXISTS gpSelect_Movement_SaleAll_PrintInvoiceIC (TDateTime, TDateTime, Integer,Integer,Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SaleAll_PrintInvoiceIC(
    IN inStartDate            TDateTime,  -- ���� ������
    IN inEndDate              TDateTime,  -- ���� ���������
    IN inJuridicalId          Integer  ,  -- ��.����
    IN inUnitId               Integer  ,  -- ������
    IN inInsuranceCompaniesId Integer  ,  -- C�������� ��������
    IN inInvoiceNDS           TFloat   ,  -- ���     
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;
    
    
    IF COALESCE (inInsuranceCompaniesId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �� ��������� ��������� ��������.';    
    END IF;
    
    IF COALESCE (inUnitId, 0) <> 0
    THEN 
      OPEN Cursor1 FOR
      WITH  tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                    , Object_BankAccount.Id
                                    , Object_BankAccount.ValueData AS BankAccount
                                    , Object_Bank.ValueData AS BankName
                                    , ObjectString_MFO.ValueData AS MFO
                               FROM Object AS Object_BankAccount
                                  LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                       ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                      AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                  LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                       ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                      AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                  LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                                  LEFT JOIN ObjectString AS ObjectString_MFO
                                                         ON ObjectString_MFO.ObjectId = Object_Bank.Id 
                                                        AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                               WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                               )

          SELECT
              Object_Juridical.ValueData                                   AS JuridicalName
            , Object_InsuranceCompanies.ValueData                          AS InsuranceCompaniesName

            , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
            , ObjectHistory_JuridicalDetails.JuridicalAddress
            , ObjectHistory_JuridicalDetails.OKPO
            , ObjectHistory_JuridicalDetails.MainName
            , ObjectHistory_JuridicalDetails.MainName_Cut
            , ObjectHistory_JuridicalDetails.AccounterName
            , ObjectHistory_JuridicalDetails.INN
            , ObjectHistory_JuridicalDetails.NumberVAT
            , ObjectHistory_JuridicalDetails.BankAccount ::TVarChar AS BankAccount 
            , ObjectHistory_JuridicalDetails.Phone
            , tmpBankAccount.BankName  ::TVarChar AS BankName
            , tmpBankAccount.MFO ::TVarChar AS MFO
            , inInvoiceNDS                  AS NDS  
            , 100:: TFloat                  AS ChangePercent
            , CURRENT_DATE::TDateTime       AS OperDate
          FROM Object AS Object_InsuranceCompanies

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON ObjectLink_Unit_Juridical.ObjectId = inUnitId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                    
              LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1

              LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                      AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount
            
          WHERE Object_InsuranceCompanies.Id = inInsuranceCompaniesId;
      RETURN NEXT Cursor1;
    ELSEIF COALESCE (inJuridicalId, 0) <> 0
    THEN 
    
      OPEN Cursor1 FOR
      WITH  tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                    , Object_BankAccount.Id
                                    , Object_BankAccount.ValueData AS BankAccount
                                    , Object_Bank.ValueData AS BankName
                                    , ObjectString_MFO.ValueData AS MFO
                               FROM Object AS Object_BankAccount
                                  LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                       ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                      AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                  LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                       ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                      AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                  LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                                  LEFT JOIN ObjectString AS ObjectString_MFO
                                                         ON ObjectString_MFO.ObjectId = Object_Bank.Id 
                                                        AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                               WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                               )

          SELECT
              Object_Juridical.ValueData                                   AS JuridicalName
            , Object_InsuranceCompanies.ValueData                          AS InsuranceCompaniesName

            , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
            , ObjectHistory_JuridicalDetails.JuridicalAddress
            , ObjectHistory_JuridicalDetails.OKPO
            , ObjectHistory_JuridicalDetails.MainName
            , ObjectHistory_JuridicalDetails.MainName_Cut
            , ObjectHistory_JuridicalDetails.AccounterName
            , ObjectHistory_JuridicalDetails.INN
            , ObjectHistory_JuridicalDetails.NumberVAT
            , ObjectHistory_JuridicalDetails.BankAccount ::TVarChar AS BankAccount 
            , ObjectHistory_JuridicalDetails.Phone
            , tmpBankAccount.BankName  ::TVarChar AS BankName
            , tmpBankAccount.MFO ::TVarChar AS MFO
            , inInvoiceNDS                  AS NDS
            , 100 :: TFloat                 AS ChangePercent
            , CURRENT_DATE::TDateTime       AS OperDate  
          FROM Object AS Object_InsuranceCompanies

              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = inJuridicalId
                                    
              LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1

              LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                      AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

          WHERE Object_InsuranceCompanies.Id = inInsuranceCompaniesId;
      RETURN NEXT Cursor1;
    
    ELSE
      RAISE EXCEPTION '������. �� ��������� ������������� ��� ��. ���� ��������.';        
    END IF;

    -- �������
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer, Address	 TVarChar) ON COMMIT DROP;

    IF (COALESCE (inJuridicalId,0) <> 0) OR (COALESCE (inUnitId,0) <> 0) THEN
       INSERT INTO tmpUnit (UnitId, JuridicalId, Address	)
                  SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                       , ObjectString_Unit_Address.ValueData  AS Address	
                  FROM ObjectLink AS OL_Unit_Juridical
                       LEFT JOIN ObjectString AS ObjectString_Unit_Address	
                              ON ObjectString_Unit_Address.ObjectId = OL_Unit_Juridical.ObjectId
                             AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ((OL_Unit_Juridical.ChildObjectId = inJuridicalId AND COALESCE (inUnitId,0) = 0)
                          OR OL_Unit_Juridical.ObjectId = inUnitId);
    ELSE
       INSERT INTO tmpUnit (UnitId, JuridicalId, Address)
                  SELECT OL_Unit_Juridical.ObjectId AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                       , ObjectString_Unit_Address.ValueData  AS Address
                  FROM ObjectLink AS OL_Unit_Juridical
                       LEFT JOIN ObjectString AS ObjectString_Unit_Address
                              ON ObjectString_Unit_Address.ObjectId = OL_Unit_Juridical.ObjectId
                             AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
    END IF;
    
    ANALYSE tmpUnit;
    
    OPEN Cursor2 FOR
      WITH
      -- �������� ������� �� ������� ���.�������
      tmpSaleAll AS (SELECT Movement_Sale.Id
                          , Movement_Sale.DescId
                          , Movement_Sale.OperDate
                          , Movement_Sale.InvNumber                              
                          , MovementLinkObject_Unit.ObjectId                 AS UnitId
                          , tmpUnit.Address
                          , tmpUnit.JuridicalId                              AS JuridicalId
                          , MovementLinkObject_InsuranceCompanies.ObjectId   AS InsuranceCompaniesId
                          , Object_MemberIC.Id                                     AS MemberICId
                          , COALESCE (Object_MemberIC.ValueData, '')  :: TVarChar  AS MemberICName
                     FROM Movement AS Movement_Sale
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                  ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_InsuranceCompanies
                                 ON MovementLinkObject_InsuranceCompanies.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_InsuranceCompanies.DescId = zc_MovementLinkObject_InsuranceCompanies()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberIC
                                 ON MovementLinkObject_MemberIC.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_MemberIC.DescId = zc_MovementLinkObject_MemberIC()
                          LEFT JOIN Object AS Object_MemberIC ON Object_MemberIC.Id = MovementLinkObject_MemberIC.ObjectId AND Object_MemberIC.DescId = zc_Object_MemberIC()

                     WHERE Movement_Sale.DescId = zc_Movement_Sale()
                       AND Movement_Sale.OperDate >=inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                       AND ( COALESCE (MovementLinkObject_InsuranceCompanies.ObjectId, 0) <> 0 OR
                             COALESCE (MovementLinkObject_MemberIC.ObjectId, 0) <> 0
                           )
                       AND (MovementLinkObject_InsuranceCompanies.ObjectId = inInsuranceCompaniesId OR inInsuranceCompaniesId = 0)
                       AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                    )
       -- �������� ������� �� ������� ���.�������
    ,  tmpMI AS (SELECT MI_Sale.ObjectId            AS GoodsId
                      , SUM(MI_Sale.Amount)::TFloat AS Amount
                      , COALESCE (MIFloat_Price.ValueData, 0)                                                              AS Price
                      , COALESCE (MIFloat_PriceSale.ValueData, 0)                                                          AS PriceSale
                      
                      , SUM(ROUND(MIFloat_PriceSale.ValueData * 100.0 / (100.0 + ObjectFloat_NDSKind_NDS.ValueData), 2))::TFloat AS PriceWithVAT
                      , SUM(ROUND(MI_Sale.Amount * MIFloat_PriceSale.ValueData, 2)::TFloat)::TFloat AS SummSale

                      , SUM(ROUND(MI_Sale.Amount * MIFloat_PriceSale.ValueData * 100.0 / (100.0 + ObjectFloat_NDSKind_NDS.ValueData), 2)::TFloat)::TFloat AS SummSaleWithVAT
                      , SUM(MI_Sale.Amount * (MIFloat_PriceSale.ValueData * ObjectFloat_NDSKind_NDS.ValueData / (100.0 + ObjectFloat_NDSKind_NDS.ValueData)))::TFloat AS SummNDS

                      , SUM(ROUND((MI_Sale.Amount * MIFloat_PriceSale.ValueData-
                                   COALESCE (MIFloat_Summ.ValueData, 0)) * 100.0 / (100.0 + ObjectFloat_NDSKind_NDS.ValueData), 2)::TFloat)::TFloat AS SummSaleWithVATIC
                      , SUM(MI_Sale.Amount * ((MIFloat_PriceSale.ValueData - COALESCE (MIFloat_Price.ValueData, 0)) * ObjectFloat_NDSKind_NDS.ValueData / (100.0 + ObjectFloat_NDSKind_NDS.ValueData)))::TFloat AS SummNDSIC
                      , SUM(ROUND(MI_Sale.Amount * MIFloat_PriceSale.ValueData - COALESCE (MIFloat_Summ.ValueData, 0), 2)::TFloat)::TFloat AS SummSaleIC

                    FROM tmpSaleAll AS Movement
                    
                         INNER JOIN MovementItem AS MI_Sale
                                                 ON MI_Sale.MovementId = Movement.Id
                                                AND MI_Sale.DescId = zc_MI_Master()
                                                AND MI_Sale.isErased = FALSE
     
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                               AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                ON MIFloat_Price.MovementItemId = MI_Sale.Id
                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                               
                         LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                     ON MIFloat_Summ.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                          
                         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MI_Sale.ObjectId
                         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                    WHERE ObjectFloat_NDSKind_NDS.ValueData = inInvoiceNDS

                    GROUP BY MI_Sale.ObjectId
                           , MIFloat_Price.ValueData
                           , MIFloat_PriceSale.ValueData)


        SELECT
            Object_Name.ObjectCode AS GoodsCode
          , Object_Name.ValueData AS GoodsName
          , MI_Sale.Amount
          , MI_Sale.PriceWithVAT
          , MI_Sale.SummSale
          , MI_Sale.SummSaleWithVAT
          , MI_Sale.SummNDS
          , MI_Sale.SummSaleWithVATIC
          , MI_Sale.SummNDSIC
          , MI_Sale.SummSaleIC
          , ROW_NUMBER()OVER(ORDER BY Object_Name.ValueData)::Integer as ORD
          , Object_Measure.ValueData            AS MeasureName


        FROM tmpMI AS MI_Sale
        
            LEFT JOIN Object AS Object_Name ON Object_Name.Id = MI_Sale.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId =  MI_Sale.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        ORDER BY
            Object_Name.ValueData;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_SaleAll_PrintInvoiceIC (TDateTime, TDateTime, Integer,Integer,Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 22.11.21                                                        *
*/

-- 


select * from gpSelect_Movement_SaleAll_PrintInvoiceIC(inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('12.06.2023')::TDateTime , inJuridicalId := 1311462 , inUnitId := 0 , inInsuranceCompaniesId := 18944516 , inInvoiceNDS := 0 ,  inSession := '3');


