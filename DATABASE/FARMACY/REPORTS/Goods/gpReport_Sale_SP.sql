-- Function:  gpReport_Sale_SP()

DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Sale_SP(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inUnitId           Integer  ,  -- Аптека
    IN inHospitalId       Integer  ,  -- Больница
    IN inGroupMemberSPId  Integer  ,  -- Категория пациента
    IN inisGroupMemberSP  Boolean  ,  -- кроме выбранной категории пациента
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitName       TVarChar
             , JuridicalName  TVarChar
             , HospitalName   TVarChar
             , InvNumberSP    TVarChar
             , MedicSP        TVarChar
             , MemberSP       TVarChar
             , GroupMemberSPName TVarChar
             , OperDateSP     TDateTime
             , OperDate       TDateTime

             , GoodsName      TVarChar
             , MeasureName    TVarChar

             , ChangePercent  TFloat
             , Amount        TFloat 
             , PriceSP        TFloat 
             , PriceOriginal  TFloat 

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
            -- выбираем продажи по товарам соц.проекта
             tmpSale AS (SELECT Movement_Sale.Id
                              , Movement_Sale.OperDate
                              , MovementLinkObject_Unit.ObjectId             AS UnitId
                              , tmpUnit.JuridicalId                          AS JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId   AS HospitalId
                              , MovementString_InvNumberSP.ValueData         AS InvNumberSP
                              , MovementString_MedicSP.ValueData             AS MedicSP
                              , MovementString_MemberSP.ValueData            AS MemberSP
                              , COALESCE (MovementDate_OperDateSP.ValueData,Null) AS OperDateSP
                              , MovementLinkObject_GroupMemberSP.ObjectId         AS GroupMemberSPId
                         FROM Movement AS Movement_Sale
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                            ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                                           AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                           
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement_Sale.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                              LEFT JOIN MovementString AS MovementString_MemberSP
                                     ON MovementString_MemberSP.MovementId = Movement_Sale.Id
                                    AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()

                              LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                   ON MovementDate_OperDateSP.MovementId = Movement_Sale.Id
                                  AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                         ON MovementLinkObject_GroupMemberSP.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()
     
                         WHERE Movement_Sale.DescId = zc_Movement_Sale()
                           AND Movement_Sale.OperDate >= inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                                 COALESCE (MovementLinkObject_GroupMemberSP.ObjectId ,0) <> 0 OR
                                 COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                                 COALESCE (MovementString_MedicSP.ValueData,'') <> '' OR
                                 COALESCE (MovementString_MemberSP.ValueData,'') <> ''
                               )
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                           AND (   (MovementLinkObject_GroupMemberSP.ObjectId =  inGroupMemberSPId AND inisGroupMemberSP = FALSE AND COALESCE(inGroupMemberSPId,0) <> 0) 
                                OR (COALESCE(MovementLinkObject_GroupMemberSP.ObjectId,0) <> inGroupMemberSPId AND inisGroupMemberSP = TRUE AND COALESCE(inGroupMemberSPId,0) <> 0)
                                OR COALESCE(inGroupMemberSPId,0) = 0
                                )
                        --   AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                        )

            -- выбираем продажи по товарам соц.проекта
            ,  tmpMI AS (SELECT Movement_Sale.OperDate
                              , Movement_Sale.UnitId
                              , Movement_Sale.JuridicalId
                              , Movement_Sale.HospitalId
                              , Movement_Sale.InvNumberSP
                              , Movement_Sale.MedicSP
                              , Movement_Sale.MemberSP
                              , Movement_Sale.OperDateSP
                              , Movement_Sale.GroupMemberSPId
                              , MI_Sale.ObjectId                                          AS GoodsId         --tmpGoods.GoodsMainId                                      AS GoodsMainId
                              , MIFloat_ChangePercent.ValueData                           AS ChangePercent
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount))  AS Amount
                              , SUM (COALESCE (MIFloat_Summ.ValueData, 0))                AS SummSale
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummOriginal
                         FROM tmpSale AS Movement_Sale
                              INNER JOIN MovementItem AS MI_Sale
                                                      ON MI_Sale.MovementId = Movement_Sale.Id
                                                     AND MI_Sale.DescId = zc_MI_Master()
                                                     AND MI_Sale.isErased = FALSE
                              INNER JOIN MovementItemBoolean AS MIBoolean_SP
                                      ON MIBoolean_SP.MovementItemId = MI_Sale.Id
                                     AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                     AND MIBoolean_SP.ValueData = TRUE

                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                     ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                              LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                     ON MIFloat_Summ.MovementItemId = MI_Sale.Id
                                    AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                     ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Sale.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         GROUP BY Movement_Sale.UnitId
                                , Movement_Sale.JuridicalId
                                , Movement_Sale.HospitalId
                                , Movement_Sale.InvNumberSP
                                , Movement_Sale.MedicSP
                                , Movement_Sale.MemberSP
                                , Movement_Sale.OperDateSP
                                , Movement_Sale.GroupMemberSPId
                                , MI_Sale.ObjectId 
                                , MIFloat_ChangePercent.ValueData
                                , Movement_Sale.OperDate
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount)) <> 0
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
             , tmpData.InvNumberSP
             , tmpData.MedicSP
             , tmpData.MemberSP
             , Object_GroupMemberSP.ValueData      AS GroupMemberSPName
             , tmpData.OperDateSP        :: TDateTime
             , tmpData.OperDate          :: TDateTime
             , Object_Goods.ValueData              AS GoodsName
             , Object_Measure.ValueData            AS MeasureName
             , tmpData.ChangePercent     :: TFloat 
             , tmpData.Amount            :: TFloat 

             , CAST ( (CASE WHEN tmpData.Amount <>0 THEN tmpData.SummSale/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) )     :: TFloat  AS PriceSP
             , CAST ( (CASE WHEN tmpData.Amount <>0 THEN tmpData.SummOriginal/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) ) :: TFloat  AS PriceOriginal
             
             , tmpData.SummSale          :: TFloat  AS SummaSP
             , tmpData.SummOriginal      :: TFloat
             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_PartnerMedical.ValueData ORDER BY Object_PartnerMedical.ValueData,  Object_Goods.ValueData ) AS Integer) AS NumLine

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

        FROM tmpMI AS tmpData
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId 
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = tmpData.GroupMemberSPId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId 

             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.HospitalId
             LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                  ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id 
                                AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()

             LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
             LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_PartnerMedical_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
 
             LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Object_Juridical.Id
                                     AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount
  

        ORDER BY Object_Unit.ValueData
               , Object_PartnerMedical.ValueData
               , Object_Goods.ValueData 
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