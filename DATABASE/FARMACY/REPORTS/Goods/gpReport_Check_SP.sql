-- Function:  gpReport_Check_SP()

DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_SP(
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
          tmpGoodsSP AS (SELECT ObjectBoolean_Goods_SP.ObjectId              AS GoodsMainId
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
                            AND ObjectBoolean_Goods_SP.ValueData = TRUE
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
                              , MAX (CASE WHEN MIFloat_SummChangePercent.ValueData < 0 THEN Movement_Check.Id ELSE 0 END) AS MovementId_err
                              , tmpGoods.GoodsMainId                                      AS GoodsMainId
                              , SUM (MI_Check.Amount) AS Amount
                              , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0))   AS SummChangePercent
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementString AS MovementString_InvNumberSP
                                                        ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                       AND MovementString_InvNumberSP.ValueData <> ''
                                                       AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                           ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                              -- еще нужно добавить ограничение по больнице
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.Amount <> 0
                                                     AND MI_Check.isErased = FALSE

                              INNER JOIN tmpGoods ON tmpGoods.GoodsId = MI_Check.ObjectId
                              --Сумма Скидки
                              LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                          ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                         AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                         GROUP BY MovementLinkObject_Unit.ObjectId
                                , tmpUnit.JuridicalId
                                , tmpGoods.GoodsMainId
                                , movementlinkobject_partnermedical.objectid
                         HAVING SUM (MI_Check.Amount) <> 0
                        )
      , tmpData AS (SELECT tmpMI.UnitId
                         , tmpMI.JuridicalId
                         , tmpMI.HospitalId
                         , tmpMI.GoodsMainId
                         , tmpMI.Amount
                         , tmpMI.SummChangePercent
                         , tmpMI.MovementId_err
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
             -- , Object_PartnerMedical.ValueData     AS HospitalName
             , CASE WHEN tmpData.MovementId_err <> 0 THEN COALESCE (Movement_err.InvNumber, '' )  || ' - ' || COALESCE (Object_Unit_err.ValueData, '') ELSE Object_PartnerMedical.ValueData END :: TVarChar AS HospitalName
             , tmpGoodsSP.IntenalSPName
             , tmpGoodsSP.BrandSPName
             , tmpGoodsSP.KindOutSPName
             , tmpGoodsSP.Pack  ::TVarChar
             , tmpGoodsSP.CountSP :: TFloat 
             , tmpGoodsSP.PriceSP :: TFloat 
             , tmpGoodsSP.GroupSP :: TFloat 
             , tmpData.Amount     :: TFloat 
             , tmpData.SummChangePercent :: TFloat  AS SummaSP
             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Unit.ValueData ORDER BY Object_Unit.ValueData, tmpGoodsSP.IntenalSPName ) AS Integer) AS NumLine

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
         /*  , ObjectHistory_PartnerMedicalDetails.OKPO              AS PartnerMedical_OKPO
           , ObjectHistory_PartnerMedicalDetails.AccounterName     AS PartnerMedical_AccounterName
           , ObjectHistory_PartnerMedicalDetails.INN               AS PartnerMedical_INN
           , ObjectHistory_PartnerMedicalDetails.NumberVAT         AS PartnerMedical_NumberVAT
           , ObjectHistory_PartnerMedicalDetails.BankAccount       AS PartnerMedical_BankAccount
           , tmpPartnerMedicalBankAccount.BankName                 AS PartnerMedical_BankName
           , tmpPartnerMedicalBankAccount.MFO                      AS PartnerMedical_MFO*/
        FROM tmpData
             LEFT JOIN Movement AS Movement_err ON Movement_err.Id = tmpData.MovementId_err
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_err
                                          ON MovementLinkObject_Unit_err.MovementId = tmpData.MovementId_err
                                         AND MovementLinkObject_Unit_err.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit_err ON Object_Unit_err.Id = MovementLinkObject_Unit_err.ObjectId

             LEFT JOIN tmpGoodsSP AS tmpGoodsSP ON tmpGoodsSP.GoodsMainId = tmpData.GoodsMainId
             
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
            /* LEFT JOIN tmpBankAccount AS tmpPartnerMedicalBankAccount 
                                      ON tmpPartnerMedicalBankAccount.JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                     AND tmpPartnerMedicalBankAccount.BankAccount = ObjectHistory_PartnerMedicalDetails.BankAccount*/
           
        ORDER BY Object_Unit.ValueData
               , tmpGoodsSP.IntenalSPName
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 20.12.16         *
*/

-- тест
-- SELECT * FROM gpReport_Check_SP (inStartDate:= '01.04.2017',inEndDate:= '15.04.2017', inJuridicalId:= 0, inUnitId:= 0, inHospitalId:= 0, inSession := '3');
