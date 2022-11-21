-- Function: gpReport_PaperRecipeSP()

--DROP FUNCTION IF EXISTS gpReport_PaperRecipeSP (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PaperRecipeSP (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PaperRecipeSP(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inJuridicalId   Integer ,   -- Юр. лицо наше
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , InsertName_Check TVarChar, TotalSumm_Check TFloat
             , UnitCode Integer, UnitName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, NDS TFloat
             , BrandSPName TVarChar, MakerSP TVarChar, KindOutSPName TVarChar, Pack TVarChar, CountSP TFloat, PriceSP TFloat
             , PriceRetSP TFloat, PaymentSP TFloat
             , PriceSale TFloat, Price TFloat, Amount TFloat, Summa TFloat, PriceCheckSP TFloat
             , SummSP TFloat, SummChangePercent TFloat
             
             , OperDateSP             TDateTime
             , InvNumberSP            TVarChar
             , MedicSPName            TVarChar
             , PartnerMedicalName     TVarChar
             , MedicalProgramSPName   TVarChar
             
             , InvNumber_Invoice      TVarChar
             , InvNumber_Invoice_Full TVarChar
             , OperDate_Invoice       TDateTime
             
             , NumLine        Integer
             , HospitalName TVarChar
             , isPrintLast Boolean
             , IntenalSPName TVarChar
             , SummaSP TFloat
             
             , JuridicalFullName  TVarChar
             , JuridicalAddress   TVarChar
             , OKPO               TVarChar
             , MainName           TVarChar
             , MainName_Cut       TVarChar
             , AccounterName      TVarChar
             , INN                TVarChar
             , NumberVAT          TVarChar
             , BankAccount        TVarChar
             , Phone              TVarChar
             , BankName           TVarChar
             , MFO                TVarChar

             , PartnerMedical_MainName         TVarChar
             , PartnerMedical_FullName         TVarChar
             , Department_FullName             TVarChar
             , Department_MainName             TVarChar
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAmountSale TFloat;
  DECLARE vbAmountIn TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
    -- Результат
    RETURN QUERY
    WITH 
        tmpMI_GoodsSP AS (SELECT tmp.MovementItemId AS Id
                               , tmp.GoodsId
                               , tmp.OperDateStart
                               , tmp.OperDateEnd
                               , tmp.OperDate
                               , tmp.MedicalProgramSPId
                          FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate, inMedicalProgramSPId := 0, inGroupMedicalProgramSPId := 0) AS tmp
                          ),
         tmpGoodsSP AS (SELECT DISTINCT MovementItem.GoodsId                        AS GoodsMainId
                            , MovementItem.MedicalProgramSPId                       AS MedicalProgramSPId
                            , MovementItem.OperDateStart                            AS OperDateStart
                            , MovementItem.OperDateEnd                              AS OperDateEnd
                            , MovementItem.OperDate                                 AS InsertDateSP
                            , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
                            , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName
                            , COALESCE(Object_BrandSP.Id ,0)             ::Integer  AS BrandSPId
                            , COALESCE(Object_BrandSP.ValueData,'')      ::TVarChar AS BrandSPName
                            , COALESCE(Object_KindOutSP.Id ,0)           ::Integer  AS KindOutSPId
                            , COALESCE(Object_KindOutSP.ValueData,'')    ::TVarChar AS KindOutSPName
                            , MIFloat_PriceSP.ValueData                             AS PriceSP
                            , MIFloat_CountSP.ValueData                             AS CountSP
                            , MIFloat_GroupSP.ValueData                             AS GroupSP
                            , MIString_Pack.ValueData                               AS Pack
                            , MIString_CodeATX.ValueData                            AS CodeATX
                            , MIString_MakerSP.ValueData                            AS MakerSP
                            , MIString_ReestrSP.ValueData                           AS ReestrSP
                            , MIString_ReestrDateSP.ValueData                       AS ReestrDateSP
                            , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                            , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
                            , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
                            , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
                            , MIFloat_PaymentSP.ValueData                           AS PaymentSP
                            , MIFloat_ColSP.ValueData                               AS ColSP
                       FROM tmpMI_GoodsSP AS MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                                        ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                        ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                        ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()  
                            LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                                        ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP() 
                            LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                                        ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP() 
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                        ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                        ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_GroupSP
                                                        ON MIFloat_GroupSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_GroupSP.DescId = zc_MIFloat_GroupSP()
                            LEFT JOIN MovementItemString AS MIString_Pack
                                                         ON MIString_Pack.MovementItemId = MovementItem.Id
                                                        AND MIString_Pack.DescId = zc_MIString_Pack()
                            LEFT JOIN MovementItemString AS MIString_CodeATX
                                                         ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                                        AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
                            LEFT JOIN MovementItemString AS MIString_MakerSP
                                                         ON MIString_MakerSP.MovementItemId = MovementItem.Id
                                                        AND MIString_MakerSP.DescId = zc_MIString_MakerSP()
                            LEFT JOIN MovementItemString AS MIString_ReestrSP
                                                         ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                                        AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()
                            LEFT JOIN MovementItemString AS MIString_ReestrDateSP
                                                         ON MIString_ReestrDateSP.MovementItemId = MovementItem.Id
                                                        AND MIString_ReestrDateSP.DescId = zc_MIString_ReestrDateSP()
                            LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                             ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                            AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 
                            LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                                             ON MI_BrandSP.MovementItemId = MovementItem.Id
                                                            AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
                            LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 
                            LEFT JOIN MovementItemLinkObject AS MI_KindOutSP
                                                             ON MI_KindOutSP.MovementItemId = MovementItem.Id
                                                            AND MI_KindOutSP.DescId = zc_MILinkObject_KindOutSP()
                            LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = MI_KindOutSP.ObjectId
                       ), 
        tmpMedicSP AS (SELECT Object_MedicSP.Id                 AS Id
                            , Object_MedicSP.ObjectCode         AS Code
                            , Object_MedicSP.ValueData          AS Name

                            , Object_PartnerMedical.Id          AS PartnerMedicalId
                            , Object_PartnerMedical.ValueData   AS PartnerMedicalName
                            
                            , ROW_NUMBER() OVER (PARTITION BY Object_MedicSP.ValueData
                                                 ORDER BY COALESCE (Object_PartnerMedical.Id, 0) DESC) AS ORD

                       FROM Object AS Object_MedicSP
                           LEFT JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                                                ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                                               AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
                           LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MedicSP_PartnerMedical.ChildObjectId
                       WHERE Object_MedicSP.DescId = zc_Object_MedicSP()
                         AND Object_MedicSP.isErased = False
                         ),
        tmpMovement AS (SELECT Movement_Check.*
                             , MovementLinkObject_SPKind.ObjectId                 AS SPKindId
                             , Object_SPKind.ValueData                            AS SPKindName
                             , MovementLinkObject_MedicalProgramSP.ObjectId       AS MedicalProgramSPId
                             , Object_MedicalProgramSP.ValueData                  AS MedicalProgramSPName
                             , Object_Insert.ValueData                            AS InsertName_Check
                             , MovementFloat_TotalSumm.ValueData                  AS TotalSumm_Check
                             , MLM_Child.MovementChildId                          AS Movement_Invoice 

                             , MovementDate_OperDateSP.ValueData                  AS OperDateSP
                             , MovementString_InvNumberSP.ValueData               AS InvNumberSP

                             , MovementString_MedicSP.ValueData                   AS MedicSPName
                             , tmpMedicSP.PartnerMedicalName                      AS PartnerMedicalName
                        FROM Movement AS Movement_Check
                             INNER JOIN MovementBoolean AS MovementBoolean_PaperRecipeSP
                                                        ON MovementBoolean_PaperRecipeSP.MovementId = Movement_Check.Id
                                                       AND MovementBoolean_PaperRecipeSP.DescId = zc_MovementBoolean_PaperRecipeSP()
                                                       AND MovementBoolean_PaperRecipeSP.ValueData = TRUE
                                                       
                             INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                           ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

                             INNER JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                                           ON MovementLinkObject_MedicalProgramSP.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                             LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MovementLinkObject_MedicalProgramSP.ObjectId

                             LEFT JOIN MovementLinkObject AS MLO_Insert
                                                          ON MLO_Insert.MovementId = Movement_Check.Id
                                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                     ON MovementFloat_TotalSumm.MovementId = Movement_Check.Id
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                             LEFT JOIN MovementLinkMovement AS MLM_Child
                                                            ON MLM_Child.MovementId = Movement_Check.Id
                                                           AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                             
                             LEFT JOIN MovementString AS MovementString_InvNumberSP
                                                      ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                     AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                             LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                    ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                             LEFT JOIN MovementString AS MovementString_MedicSP
                                                      ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                                                     
                             LEFT JOIN tmpMedicSP ON tmpMedicSP.Name = MovementString_MedicSP.ValueData
                                                 AND tmpMedicSP.ORD = 1 
                             
                        WHERE Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_Complete() 
                          AND Movement_Check.OperDate >= inStartDate
                          AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' 
                          AND  MovementLinkObject_MedicalProgramSP.ObjectId NOT IN (18078185, 18078194, 18078210, 18078197, 18078175)
                        ),
        tmpMovement_Invoice AS (SELECT Movement_Invoice.Id
                                     , Movement_Invoice.InvNumber                 :: TVarChar    AS InvNumber_Invoice 
                                     , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full
                                     , Movement_Invoice.OperDate                                 AS OperDate_Invoice
                                FROM  Movement AS Movement_Invoice 
                                WHERE Movement_Invoice.Id in (SELECT Movement_Invoice FROM tmpMovement)
                                )
 
      , tmpMovementItem AS (SELECT *
                            FROM MovementItem
                            WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.Amount <> 0
                              AND MovementItem.isErased = FALSE
                            ) 
        --свернули т.к. если идет несколько контейнеров задваиваются строки в отчете
      , tmpMIContainer AS (SELECT MovementItemContainer.MovementId
                                , MovementItemContainer.MovementItemId
                                , SUM (COALESCE(MovementItemContainer.Amount,0)) AS Amount
                           FROM MovementItemContainer
                           WHERE MovementItemContainer.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                             AND MovementItemContainer.MovementItemId IN (SELECT tmpMovementItem.Id FROM tmpMovementItem)
                             AND MovementItemContainer.DescId = zc_MIContainer_Count() 
                           GROUP BY MovementItemContainer.MovementId
                                  , MovementItemContainer.MovementItemId
                           )

      , tmpMI_All AS (SELECT Movement.*
                           , MovementItem.Id        AS MovementItemId
                           , MovementItem.ObjectId  AS GoodsId
                           , COALESCE(MovementItem.Amount, - MovementItemContainer.Amount)::TFloat AS Amount
                           , COALESCE (MIFloat_SummChangePercent.ValueData * MovementItem.Amount /
                             COALESCE(MovementItem.Amount, - MovementItemContainer.Amount), 0)::TFloat             AS SummChangePercent
                           , COALESCE (MIFloat_PriceSale.ValueData, 0)::TFloat                     AS PriceSale
                           , COALESCE (MIFloat_Price.ValueData, 0)::TFloat                         AS Price
                         --  , MovementItemContainer.ContainerId
                      FROM tmpMovement AS Movement
                       
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.Amount <> 0
                                                  AND MovementItem.isErased = FALSE    
                                                  
                           INNER JOIN tmpMIContainer AS MovementItemContainer
                                                     ON MovementItemContainer.MovementId = Movement.Id
                                                    AND MovementItemContainer.MovementItemId = MovementItem.Id
                                                  
                           --Сумма Скидки
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                       ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     )

      , tmpMI AS (SELECT tmpMI.*
                       /*, COALESCE (MI_Income_find.Id, MI_Income.Id) AS MI_IncomeId
                       , COALESCE (MI_Income_find.Id, MI_Income.Id) AS MI_IncomeId*/
                  FROM tmpMI_All AS tmpMI
                  
/*                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                     ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                       -- элемент прихода
                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                       -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                       -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)*/
                 ),
                 
        tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
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
                           ),                 
        tmpParam AS (SELECT tmp.JuridicalId
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
                       FROM (SELECT DISTINCT ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalId
                             FROM tmpMI

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = tmpMI.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                  
                                  INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()                             
                             ) AS tmp

                          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmp.JuridicalId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
       
                          LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = tmp.JuridicalId
                                                  AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

                       )
                 

  SELECT tmpMI.Id
       , tmpMI.InvNumber 
       , tmpMI.OperDate
       , tmpMI.InsertName_Check
       , tmpMI.TotalSumm_Check
       , Object_Unit.ObjectCode          AS UnitCode
       , Object_Unit.ValueData           AS UnitName 
       , Object_Juridical.Id             AS JuridicalId
       , Object_Juridical.ObjectCode     AS JuridicalCode
       , Object_Juridical.ValueData      AS JuridicalName 
       , Object_Goods_Main.ObjectCode    AS GoodsCode
       , Object_Goods_Main.Name          AS GoodsName
       , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
       
       , tmpGoodsSP.BrandSPName
       , tmpGoodsSP.MakerSP
       , tmpGoodsSP.KindOutSPName
       , tmpGoodsSP.Pack
       , tmpGoodsSP.CountSP
       , tmpGoodsSP.PriceSP
       , tmpGoodsSP.PriceRetSP
       , tmpGoodsSP.PaymentSP

       , tmpMI.PriceSale
       , tmpMI.Price
       , tmpMI.Amount
       , Round(tmpMI.Price * tmpMI.Amount, 2):: TFloat
       , CAST ((tmpMI.SummChangePercent / tmpMI.Amount) AS NUMERIC(16,2)):: TFloat AS PriceCheckSP
       
       , Round(tmpGoodsSP.PriceSP * tmpMI.Amount, 2):: TFloat AS SummSP
       , tmpMI.SummChangePercent
       
       , tmpMI.OperDateSP
       , tmpMI.InvNumberSP
       , tmpMI.MedicSPName
       , tmpMI.PartnerMedicalName
       , tmpMI.MedicalProgramSPName
             
       , Movement_Invoice.InvNumber_Invoice
       , Movement_Invoice.InvNumber_Invoice_Full
       , Movement_Invoice.OperDate_Invoice  
       
       , CAST (ROW_NUMBER() OVER (PARTITION BY Object_Juridical.Id, Object_Unit.Id ORDER BY tmpGoodsSP.BrandSPName, tmpMI.OperDate ) AS Integer) AS NumLine  
       , ''::TVarChar    AS HospitalName
       , False           AS isPrintLast
       , tmpGoodsSP.BrandSPName    AS IntenalSPName
       , tmpMI.SummChangePercent   AS SummaSP
       
       
       , COALESCE (tmpParam.JuridicalFullName, Object_Juridical.ValueData ) :: TVarChar  AS JuridicalFullName
             
       , COALESCE (tmpParam.JuridicalAddress, '') :: TVarChar  AS JuridicalAddress
       , COALESCE (tmpParam.OKPO, '')                        :: TVarChar  AS OKPO
       , COALESCE (tmpParam.MainName, '')                :: TVarChar  AS MainName
             
       , COALESCE (tmpParam.MainName_Cut, tmpParam.MainName)  :: TVarChar  AS MainName_Cut
       , COALESCE (tmpParam.AccounterName, '')  :: TVarChar AS AccounterName
       , COALESCE (tmpParam.INN, '')                      :: TVarChar AS INN
       , COALESCE (tmpParam.NumberVAT,'')           :: TVarChar AS NumberVAT
       , COALESCE (tmpParam.BankAccount, '')      :: TVarChar AS BankAccount
       , COALESCE (tmpParam.Phone, '')                  :: TVarChar AS Phone
       , COALESCE (tmpParam.BankName, '')            :: TVarChar AS BankName
       , COALESCE (tmpParam.MFO, '')                      :: TVarChar AS MFO

       , ''::TVarChar    AS PartnerMedical_MainName
       , ''::TVarChar    AS PartnerMedical_FullName
       , ''::TVarChar    AS Department_FullName
       , ''::TVarChar    AS Department_MainName
       
  FROM tmpMI

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = tmpMI.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
       
       INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

       INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpMI.GoodsId
       INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

       LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                             ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                            AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

       LEFT JOIN tmpGoodsSP AS tmpGoodsSP 
                            ON tmpGoodsSP.GoodsMainId = Object_Goods_Main.Id
                           AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) >= tmpGoodsSP.OperDateStart
                           AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) <= tmpGoodsSP.OperDateEnd
                           AND tmpGoodsSP.MedicalProgramSPId = tmpMI.MedicalProgramSPId

       -- счет
       LEFT JOIN tmpMovement_Invoice AS Movement_Invoice ON Movement_Invoice.Id = tmpMI.Movement_Invoice

       LEFT JOIN tmpParam ON tmpParam.JuridicalId = ObjectLink_Unit_Juridical.ChildObjectId

  WHERE Object_Juridical.Id = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0
  ORDER BY tmpMI.OperDate, tmpMI.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PaperRecipeSP (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
--    select * from gpReport_PaperRecipeSP(inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('30.04.2022')::TDateTime , inJuridicalId := 0 ,  inSession := '3');
