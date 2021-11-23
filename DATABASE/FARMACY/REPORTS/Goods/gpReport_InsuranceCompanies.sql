-- Function:  gpReport_InsuranceCompanies()

DROP FUNCTION IF EXISTS gpReport_InsuranceCompanies (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_InsuranceCompanies(
    IN inStartDate            TDateTime,  -- Дата начала
    IN inEndDate              TDateTime,  -- Дата окончания
    IN inJuridicalId          Integer  ,  -- Юр.лицо
    IN inUnitId               Integer  ,  -- Аптека
    IN inInsuranceCompaniesId Integer  ,  -- Cтраховая компания
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer
             , UnitName       TVarChar
             , Unit_Addres	   TVarChar
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , InsuranceCompaniesId     Integer
             , InsuranceCompaniesName   TVarChar
             , MemberICName             TVarChar
             , InsuranceCardNumber      TVarChar
             , OperDate       TDateTime
             , InvNumber_Full    TVarChar

             , GoodsCode      Integer
             , GoodsName      TVarChar
             , MeasureName    TVarChar
             , isResolution_224 Boolean

             , ChangePercent  TFloat
             , Amount         TFloat
             , PriceSale      TFloat
             , SummaSale      TFloat
             , NDS            TFloat

             , NumLine        Integer

             , JuridicalFullName  TVarChar
             , JuridicalAddress  TVarChar
             , OKPO               TVarChar
             , AccounterName      TVarChar
             , INN                TVarChar
             , NumberVAT          TVarChar
             , BankAccount        TVarChar
             , Phone              TVarChar
             , MainName           TVarChar
             , Reestr             TVarChar
             , Decision           TVarChar
             , DecisionDate       TDateTime
             , License            TVarChar

             , InsuranceCompanies_JuridicalName    TVarChar
             , InsuranceCompanies_FullName         TVarChar
             , InsuranceCompanies_JuridicalAddress TVarChar
             , InsuranceCompanies_Phone            TVarChar

             , InsuranceCompanies_OKPO             TVarChar
             , InsuranceCompanies_AccounterName    TVarChar
             , InsuranceCompanies_INN              TVarChar
             , InsuranceCompanies_NumberVAT        TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- Таблицы
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

    -- Результат
    RETURN QUERY
          WITH
          -- выбираем продажи по товарам соц.проекта
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
            -- выбираем продажи по товарам соц.проекта
            ,  tmpMI AS (SELECT Movement_Sale.Id   AS MovementId
                              , Movement_Sale.OperDate
                              , Movement_Sale.UnitId
                              , Movement_Sale.Address
                              , Movement_Sale.JuridicalId
                              , Movement_Sale.InsuranceCompaniesId
                              , Movement_Sale.MemberICId
                              , Movement_Sale.MemberICName
                              , MI_Sale.ObjectId                                   AS GoodsId
                              , MIFloat_ChangePercent.ValueData                    AS ChangePercent
                              , MI_Sale.Amount
                              , MIFloat_PriceSale.ValueData                                  AS PriceSale
                              , MI_Sale.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)   AS SummSale
                         FROM tmpSaleAll AS Movement_Sale
                              INNER JOIN MovementItem AS MI_Sale
                                                      ON MI_Sale.MovementId = Movement_Sale.Id
                                                     AND MI_Sale.DescId = zc_MI_Master()
                                                     AND MI_Sale.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                     ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MI_Sale.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        )                        
                          
 , tmpMovDetails AS (SELECT tmpSale.Id                              AS MovementId
                          , tmpSale.OperDate
                          , tmpSale.InvNumber
                          
                          
                          , tmpSale.UnitId
                          , tmpSale.Address
                          , tmpSale.JuridicalId
                          , tmpSale.InsuranceCompaniesId
                          , tmpSale.MemberICId
                          , tmpSale.MemberICName

                          , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
                          , ObjectHistory_JuridicalDetails.JuridicalAddress
                          , ObjectHistory_JuridicalDetails.OKPO
                          , ObjectHistory_JuridicalDetails.AccounterName
                          , ObjectHistory_JuridicalDetails.INN
                          , ObjectHistory_JuridicalDetails.NumberVAT
                          , ObjectHistory_JuridicalDetails.BankAccount
                          , ObjectHistory_JuridicalDetails.Phone

                          , ObjectHistory_JuridicalDetails.MainName
                          , ObjectHistory_JuridicalDetails.Reestr
                          , ObjectHistory_JuridicalDetails.Decision
                          , ObjectHistory_JuridicalDetails.DecisionDate
                          , ObjectHistory_JuridicalDetails.License

                          , ObjectLink_InsuranceCompanies_Juridical.ChildObjectId     AS InsuranceCompanies_JuridicalId  --ObjectLink_InsuranceCompanies_Juridical.ChildObjectId     AS InsuranceCompanies_JuridicalId
                          , ObjectHistory_InsuranceCompaniesDetails.FullName          AS InsuranceCompanies_FullName
                          , ObjectHistory_InsuranceCompaniesDetails.JuridicalAddress  AS InsuranceCompanies_JuridicalAddress
                          , ObjectHistory_InsuranceCompaniesDetails.Phone             AS InsuranceCompanies_Phone
                          , ObjectHistory_InsuranceCompaniesDetails.OKPO              AS InsuranceCompanies_OKPO
                          , ObjectHistory_InsuranceCompaniesDetails.AccounterName     AS InsuranceCompanies_AccounterName
                          , ObjectHistory_InsuranceCompaniesDetails.INN               AS InsuranceCompanies_INN
                          , ObjectHistory_InsuranceCompaniesDetails.NumberVAT         AS InsuranceCompanies_NumberVAT

                     FROM tmpSaleAll AS tmpSale

                       LEFT JOIN ObjectLink AS ObjectLink_InsuranceCompanies_Juridical
                              ON ObjectLink_InsuranceCompanies_Juridical.ObjectId = tmpSale.InsuranceCompaniesId
                             AND ObjectLink_InsuranceCompanies_Juridical.DescId = zc_ObjectLink_InsuranceCompanies_Juridical()

                       LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmpSale.JuridicalId, inFullName := '', inOKPO := '', inSession := '3' /*inSession*/) AS ObjectHistory_JuridicalDetails ON 1=1
                       LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_InsuranceCompanies_Juridical.ChildObjectId , inFullName := '', inOKPO := '', inSession := '3' /*inSession*/) AS ObjectHistory_InsuranceCompaniesDetails ON 1=1

                    )
                    
        -- результат
        SELECT tmpData.MovementId
             , Object_Unit.ValueData               AS UnitName
             , tmpMovDetails.Address               AS Unit_Address
             , Object_Juridical.Id                 AS JuridicalId
             , Object_Juridical.ValueData          AS JuridicalName
             , Object_InsuranceCompanies.Id            AS InsuranceCompaniesId
             , Object_InsuranceCompanies.ValueData     AS InsuranceCompaniesName
             , tmpData.MemberICName
             , COALESCE (ObjectString_InsuranceCardNumber.ValueData, '')   :: TVarChar  AS InsuranceCardNumber
          
             , tmpData.OperDate          :: TDateTime
             , tmpMovDetails.InvNumber
             , Object_Goods_Main.ObjectCode        AS GoodsCode
             , Object_Goods_Main.Name              AS GoodsName
             , Object_Measure.ValueData            AS MeasureName
             , Object_Goods_Main.isResolution_224 :: Boolean
             , tmpData.ChangePercent     :: TFloat
             , tmpData.Amount            :: TFloat

             , tmpData.PriceSale :: TFloat
             , tmpData.SummSale  :: TFloat
             , ObjectFloat_NDSKind_NDS.ValueData     AS NDS

             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_InsuranceCompanies.ValueData   ORDER BY Object_Unit.ValueData, Object_Goods_Main.Name) AS Integer) AS NumLine

           , COALESCE (tmpMovDetails.JuridicalFullName,Object_Juridical.ValueData)
           , tmpMovDetails.JuridicalAddress
           , tmpMovDetails.OKPO
           , tmpMovDetails.AccounterName
           , tmpMovDetails.INN
           , tmpMovDetails.NumberVAT
           , tmpMovDetails.BankAccount
           , tmpMovDetails.Phone
           , tmpMovDetails.MainName
           , tmpMovDetails.Reestr
           , tmpMovDetails.Decision
           , tmpMovDetails.DecisionDate
           , tmpMovDetails.License

           , Object_InsuranceCompaniesJuridical.ValueData AS InsuranceCompanies_JuridicalName
           , tmpMovDetails.InsuranceCompanies_FullName
           , tmpMovDetails.InsuranceCompanies_JuridicalAddress
           , tmpMovDetails.InsuranceCompanies_Phone
           , tmpMovDetails.InsuranceCompanies_OKPO
           , tmpMovDetails.InsuranceCompanies_AccounterName
           , tmpMovDetails.InsuranceCompanies_INN
           , tmpMovDetails.InsuranceCompanies_NumberVAT
        FROM tmpMI AS tmpData

             LEFT JOIN tmpMovDetails ON tmpData.MovementId = tmpMovDetails.MovementId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId AND Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId AND Object_Juridical.DescId = zc_Object_Juridical()
             LEFT JOIN Object AS Object_InsuranceCompanies ON Object_InsuranceCompanies.Id = tmpData.InsuranceCompaniesId  AND Object_InsuranceCompanies.DescId = zc_Object_InsuranceCompanies()
             LEFT JOIN Object AS Object_InsuranceCompaniesJuridical ON Object_InsuranceCompaniesJuridical.Id = tmpMovDetails.InsuranceCompanies_JuridicalId  AND Object_InsuranceCompaniesJuridical.DescId = zc_Object_InsuranceCompanies()

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_Goods_Main.Measureid

             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = Object_Goods_Main.NDSKindId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

             LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber
                                    ON ObjectString_InsuranceCardNumber.ObjectId = tmpData.MemberICId
                                   AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber()
             
         ORDER BY Object_InsuranceCompanies.ValueData
                , Object_Unit.ValueData 
                , Object_Goods_Main.Name;
                
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.11.21                                                       *
*/

-- тест
-- 

select * from gpReport_InsuranceCompanies(inStartDate := ('01.10.2021')::TDateTime , inEndDate := ('31.10.2021')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inInsuranceCompaniesId := 17988780 ,  inSession := '3');