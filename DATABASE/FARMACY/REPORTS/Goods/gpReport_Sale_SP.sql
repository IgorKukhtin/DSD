-- Function:  gpReport_Sale_SP()

DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Sale_SP(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inUnitId           Integer  ,  -- Аптека
    IN inHospitalId       Integer  ,  -- Больница
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitName       TVarChar
             , JuridicalName  TVarChar
             , HospitalName   TVarChar
             , IntenalSPName  TVarChar
             , BrandSPName    TVarChar
             , KindOutSPName  TVarChar
             , Pack           TVarChar
             , CountSP        TFloat
             , PriceSP        TFloat 
             , GroupSP        TFloat 
             , Amount         TFloat 
             , SummaSP        TFloat
             , SummOriginal   TFloat
             , NumLine        Integer

           , JuridicalFullName  TVarChar
           , JuridicalAddress   TVarChar
           , OKPO               TVarChar
           , AccounterName      TVarChar
           , INN                TVarChar
           , NumberVAT          TVarChar
           , BankAccount        TVarChar
           , Phone              TVarChar
           , BankName           TVarChar
           , MFO                TVarChar

           , PartnerMedical_FullName         TVarChar
           , PartnerMedical_JuridicalAddress TVarChar
           , PartnerMedical_Phone            TVarChar
           /*, PartnerMedical_OKPO             TVarChar
           , PartnerMedical_AccounterName    TVarChar
           , PartnerMedical_INN              TVarChar
           , PartnerMedical_NumberVAT        TVarChar
           , PartnerMedical_BankAccount      TVarChar
           , PartnerMedical_BankName         TVarChar
           , PartnerMedical_MFO              TVarChar*/
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    
    -- Таблицы
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer) ON COMMIT DROP;
 
    IF (COALESCE (inJuridicalId,0) <> 0) OR (COALESCE (inUnitId,0) <> 0) THEN
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ((OL_Unit_Juridical.ChildObjectId = inJuridicalId AND COALESCE (inUnitId,0) = 0)
                          OR OL_Unit_Juridical.ObjectId = inUnitId);
    ELSE 
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
    END IF;

    -- Результат
    RETURN QUERY
          WITH
          -- выбираем товары спец. проекта (главные)
          tmpGoodsSP AS (SELECT Distinct MI_Sale.ObjectId   AS GoodsMainId--tmpGoods.GoodsMainId                                      AS GoodsMainId
                         FROM Movement AS Movement_Sale
                              INNER JOIN MovementItem AS MI_Sale
                                                      ON MI_Sale.MovementId = Movement_Sale.Id
                                                     AND MI_Sale.DescId = zc_MI_Master()
                                                     AND MI_Sale.isErased = FALSE
                              INNER JOIN MovementItemBoolean AS MIBoolean_SP
                                      ON MIBoolean_SP.MovementItemId = MI_Sale.Id
                                     AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                     AND MIBoolean_SP.ValueData = TRUE

                         WHERE Movement_Sale.DescId = zc_Movement_Sale()
/*SELECT ObjectBoolean_Goods_SP.ObjectId              AS GoodsMainId
                              , ObjectLink_Goods_IntenalSP.ChildObjectId     AS IntenalSPId
                              , Object_IntenalSP.ValueData                   AS IntenalSPName
                              , ObjectLink_Goods_BrandSP.ChildObjectId       AS BrandSPId
                              , Object_BrandSP.ValueData                     AS BrandSPName
                              , ObjectLink_Goods_KindOutSP.ChildObjectId     AS KindOutSPId
                              , Object_KindOutSP.ValueData                   AS KindOutSPName

                              , ObjectFloat_Goods_PriceSP.ValueData          AS PriceSP
                              , ObjectFloat_Goods_GroupSP.ValueData          AS GroupSP
                              , ObjectFloat_Goods_CountSP.ValueData          AS CountSP
                              , ObjectString_Goods_Pack.ValueData            AS Pack  --дозировка

                          FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                               LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
        
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_BrandSP
                                 ON ObjectLink_Goods_BrandSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_BrandSP.DescId = zc_ObjectLink_Goods_BrandSP()
                               LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = ObjectLink_Goods_BrandSP.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_KindOutSP
                                 ON ObjectLink_Goods_KindOutSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_KindOutSP.DescId = zc_ObjectLink_Goods_KindOutSP()
                               LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = ObjectLink_Goods_KindOutSP.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                 ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_GroupSP
                                 ON ObjectFloat_Goods_GroupSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_GroupSP.DescId = zc_ObjectFloat_Goods_GroupSP()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountSP
                                 ON ObjectFloat_Goods_CountSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_CountSP.DescId = zc_ObjectFloat_Goods_CountSP()

                               LEFT JOIN ObjectString AS ObjectString_Goods_Pack
                                 ON ObjectString_Goods_Pack.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectString_Goods_Pack.DescId = zc_ObjectString_Goods_Pack()
    
                          WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                            AND ObjectBoolean_Goods_SP.ValueData = TRUE*/
                         )
           -- связываем главные товары с товарами сети
           , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                               , tmpGoodsSP.GoodsMainId
                          FROM tmpGoodsSP
                               INNER JOIN ObjectLink AS ObjectLink_Main
                                  ON ObjectLink_Main.ChildObjectId = tmpGoodsSP.GoodsMainId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                               INNER JOIN ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 AND COALESCE (ObjectLink_Child.ChildObjectId,0)<>0
                          )
            -- выбираем продажи по товарам соц.проекта
            ,  tmpMI AS (SELECT MovementLinkObject_Unit.ObjectId                          AS UnitId
                              , tmpUnit.JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId                AS HospitalId
                              , MI_Sale.ObjectId   AS GoodsMainId--tmpGoods.GoodsMainId                                      AS GoodsMainId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount))  AS Amount
                              , SUM (COALESCE (MIFloat_Summ.ValueData, 0))                AS SummSale
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummOriginal
                         FROM Movement AS Movement_Sale
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
 
                              INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                            ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                                           AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)

                              INNER JOIN MovementItem AS MI_Sale
                                                      ON MI_Sale.MovementId = Movement_Sale.Id
                                                     AND MI_Sale.DescId = zc_MI_Master()
                                                     AND MI_Sale.isErased = FALSE
                              INNER JOIN MovementItemBoolean AS MIBoolean_SP
                                      ON MIBoolean_SP.MovementItemId = MI_Sale.Id
                                     AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                     AND MIBoolean_SP.ValueData = TRUE

                              --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MI_Sale.ObjectId
                              /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MI_Sale.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()*/
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                     ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                              LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                     ON MIFloat_Summ.MovementItemId = MI_Sale.Id
                                    AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                            /*  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                     ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()*/

                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Sale.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Sale.DescId = zc_Movement_Sale()
                           AND Movement_Sale.OperDate >= inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                        --   AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MovementLinkObject_Unit.ObjectId
                                , tmpUnit.JuridicalId
                                ,MI_Sale.ObjectId  --, tmpGoods.GoodsMainId
                                , movementlinkobject_partnermedical.objectid
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount)) <> 0
                        )
      , tmpData AS (SELECT tmpMI.UnitId
                         , tmpMI.JuridicalId
                         , tmpMI.HospitalId
                         , tmpMI.GoodsMainId
                         , tmpMI.Amount
                         , tmpMI.SummSale
                         , tmpMI.SummOriginal
                    FROM tmpMI 
                    )

      , tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
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
        -- результат
        SELECT Object_Unit.ValueData               AS UnitName
             , Object_Juridical.ValueData          AS JuridicalName
             , Object_PartnerMedical.ValueData     AS HospitalName
             , Object_Goods.ValueData AS IntenalSPName--tmpGoodsSP.IntenalSPName
             , ''  ::TVarChar AS BrandSPName --tmpGoodsSP.BrandSPName
             , ''  ::TVarChar AS KindOutSPName --tmpGoodsSP.KindOutSPName
             , ''  ::TVarChar AS Pack --tmpGoodsSP.Pack  ::TVarChar
             , 0  :: TFloat  AS CountSP --tmpGoodsSP.CountSP :: TFloat 
             , 0  :: TFloat  AS PriceSP --tmpGoodsSP.PriceSP :: TFloat 
             , 0  :: TFloat  AS GroupSP --tmpGoodsSP.GroupSP :: TFloat 
             , tmpData.Amount     :: TFloat 
             , tmpData.SummSale :: TFloat  AS SummaSP
             , tmpData.SummOriginal :: TFloat
             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Unit.ValueData ORDER BY Object_Unit.ValueData,  Object_Goods.ValueData ) AS Integer) AS NumLine

           , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
           , ObjectHistory_JuridicalDetails.JuridicalAddress
           , ObjectHistory_JuridicalDetails.OKPO
           , ObjectHistory_JuridicalDetails.AccounterName
           , ObjectHistory_JuridicalDetails.INN
           , ObjectHistory_JuridicalDetails.NumberVAT
           , ObjectHistory_JuridicalDetails.BankAccount
           , ObjectHistory_JuridicalDetails.Phone
           , tmpBankAccount.BankName ::TVarChar
           , tmpBankAccount.MFO      ::TVarChar

           , ObjectHistory_PartnerMedicalDetails.FullName          AS PartnerMedical_FullName
           , ObjectHistory_PartnerMedicalDetails.JuridicalAddress  AS PartnerMedical_JuridicalAddress
           , ObjectHistory_PartnerMedicalDetails.Phone             AS PartnerMedical_Phone

        FROM tmpData
             LEFT JOIN tmpGoodsSP AS tmpGoodsSP ON tmpGoodsSP.GoodsMainId = tmpData.GoodsMainId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsMainId 
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.HospitalId
             LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                  ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id 
                                AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()

             LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
             LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_PartnerMedical_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
 
             LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                     AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount
        ORDER BY Object_Unit.ValueData
             --   , tmpGoodsSP.IntenalSPName
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 10.02.17         *
*/

-- тест
--SELECT * FROM gpReport_Sale_SP(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('29.12.2016')::TDateTime,  inSession := '3');
--select * from gpReport_Sale_SP(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('20.12.2016')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 ,  inSession := '3');