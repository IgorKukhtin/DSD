-- Function:  gpReport_Check_SP()

DROP FUNCTION IF EXISTS gpReport_Check_SP_01042019 (TDateTime, TDateTime, Integer,Integer,Integer,Integer,Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Check_SP_01042019(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalId         Integer  ,  -- Юр.лицо
    IN inUnitId              Integer  ,  -- Аптека
    IN inHospitalId          Integer  ,  -- Больница
    IN inJuridicalMedicId    Integer  ,  -- Юр.лицо плательщик с 01,04,2019
    IN inMedicalProgramSPId  Integer  ,  -- Медицинская программа соц. проектов
    IN inGroupMedicalProgramSPId Integer  ,  -- Группа медицинских программ соц. проектов
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer
             , InvNumber_Full TVarChar
             , UnitName       TVarChar
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , HospitalId     Integer
             , HospitalName   TVarChar
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , IntenalSPName  TVarChar
             , BrandSPName    TVarChar
             , KindOutSPName  TVarChar
             , Pack           TVarChar
             , CountSP        TFloat
             , PriceSP        TFloat 
             , GroupSP        TFloat 
             , CodeATX        TVarChar
             , ReestrSP       TVarChar
             , MakerSP        TVarChar
             , DateReestrSP   TVarChar
             , PriceOptSP     TFloat
             , PriceRetSP     TFloat
             , DailyNormSP    TFloat
             , DailyCompensationSP  TFloat
             , PaymentSP      TFloat
             , ColSP          TFloat
             , InsertDateSP   TDateTime
             , IdSP           TVarChar

             , Amount         TFloat
             , PriceSale      TFloat
             , PriceCheckSP   TFloat 
             , PriceWithVAT   TFloat 
             , SummaSP        TFloat
             , SummaSale      TFloat
             , SummaSP_pack   TFloat
             , NumLine        Integer
             , CountInvNumberSP  Integer

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
  
             , PartnerMedical_FullName         TVarChar
             , PartnerMedical_JuridicalAddress TVarChar
             , PartnerMedical_OKPO             TVarChar
             , PartnerMedical_Phone            TVarChar
             /*
             , PartnerMedical_AccounterName    TVarChar
             , PartnerMedical_INN              TVarChar
             , PartnerMedical_NumberVAT        TVarChar*/
             , PartnerMedical_BankAccount      TVarChar
             , PartnerMedical_BankName         TVarChar
             , PartnerMedical_MFO              TVarChar
             , PartnerMedical_MainName         TVarChar
             , PartnerMedical_MainName_Cut     TVarChar
             , ContractId          Integer
             , ContractName        TVarChar
             , Contract_StartDate              TDateTime
             , Contract_SigningDate            TDateTime
             
             , DepartmentId                 Integer
             , Department_FullName          TVarChar
             , Department_JuridicalAddress  TVarChar
             , Department_OKPO              TVarChar
             , Department_Phone             TVarChar
             , Department_BankAccount       TVarChar
             , Department_BankName          TVarChar
             , Department_MFO               TVarChar
             , Department_MainName          TVarChar
             , Department_MainName_Cut      TVarChar
             , ContractId_Department        Integer
             , ContractName_Department      TVarChar
             , Contract_StartDate_Department   TDateTime
             , Contract_SigningDate_Department TDateTime

             , MedicSPName                        TVarChar
             , InvNumberSP                        TVarChar
             , OperDateSP                         TDateTime
             , OperDate                           TDateTime
  
             , InvNumber_Invoice      TVarChar
             , InvNumber_Invoice_Full TVarChar
             , OperDate_Invoice       TDateTime
             , TotalSumm_Invoice      TFloat

             , isPrintLast       Boolean

             , TotalSumm_Check TFloat
             , InsertName_Check TVarChar
             , InsertDate_Check TDateTime
             , NDS TFloat
             , MedicalProgramSPName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartYear TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbStartYear := (SELECT DATE_TRUNC ('YEAR' ,inStartDate)) ::TDateTime;
    
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
           --  Все Товары соц-проект (документ)
            tmpMI_GoodsSP AS (SELECT tmp.MovementItemId AS Id
                                   , tmp.GoodsId
                                   , tmp.OperDateStart
                                   , tmp.OperDateEnd
                                   , tmp.OperDate
                                   , tmp.MedicalProgramSPId
                              FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate, inMedicalProgramSPId := inMedicalProgramSPId, inGroupMedicalProgramSPId := inGroupMedicalProgramSPId) AS tmp
                              )

          , tmpGoodsSP AS (SELECT DISTINCT MovementItem.GoodsId                         AS GoodsMainId
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
                                , COALESCE (MIString_IdSP.ValueData, '')     ::TVarChar AS IdSP
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
                                LEFT JOIN MovementItemString AS MIString_IdSP
                                                             ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                            AND MIString_IdSP.DescId = zc_MIString_IdSP()
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
                           )

           -- связываем главные товары с товарами сети
        , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                            , tmpGoodsSP.GoodsMainId
                       FROM (SELECT DISTINCT tmpGoodsSP.GoodsMainId FROM tmpGoodsSP) AS tmpGoodsSP
                            INNER JOIN ObjectLink AS ObjectLink_Main
                                                  ON ObjectLink_Main.ChildObjectId = tmpGoodsSP.GoodsMainId
                                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Child 
                                                  ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 AND COALESCE (ObjectLink_Child.ChildObjectId,0)<>0
                       )

      -- выбираем продажи по товарам соц.проекта
        , tmpMovement_All AS (SELECT Movement_Check.Id                                         AS Id 
                                   , Movement_Check.OperDate
                                   , MovementLinkObject_Unit.ObjectId                          AS UnitId
                                   , tmpUnit.JuridicalId
                                   , MovementLinkObject_PartnerMedical.ObjectId                AS HospitalId
                                   , MovementString_InvNumberSP.ValueData                      AS InvNumberSP
                                   , COALESCE (MovementLinkObject_MedicalProgramSP.ObjectId, 18076882) AS MedicalProgramSPId
                              FROM Movement AS Movement_Check
                                   INNER JOIN MovementString AS MovementString_InvNumberSP
                                                             ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                            AND MovementString_InvNumberSP.ValueData <> ''
                                                            AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                   INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
     
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                                ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                               AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                           
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                                ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                                               AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
     
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                                                ON MovementLinkObject_MedicalProgramSP.MovementId = Movement_Check.Id
                                                               AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                                                               
                                   LEFT JOIN ObjectLink AS ObjectLink_GroupMedicalProgramSP
                                                        ON ObjectLink_GroupMedicalProgramSP.ObjectId = COALESCE (MovementLinkObject_MedicalProgramSP.ObjectId, 18076882)
                                                       AND ObjectLink_GroupMedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP()
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                                           ON ObjectBoolean_ElectronicPrescript.ObjectId =COALESCE (MovementLinkObject_MedicalProgramSP.ObjectId, 18076882)
                                                          AND ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()

                                   LEFT JOIN MovementBoolean AS MovementBoolean_PaperRecipeSP
                                                             ON MovementBoolean_PaperRecipeSP.MovementId = Movement_Check.Id
                                                            AND MovementBoolean_PaperRecipeSP.DescId = zc_MovementBoolean_PaperRecipeSP()

                              WHERE Movement_Check.DescId = zc_Movement_Check()
                                AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                                AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                                AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                                AND COALESCE (MovementLinkObject_SPKind.ObjectId, 0) = zc_Enum_SPKind_SP()
                                AND (COALESCE (MovementLinkObject_MedicalProgramSP.ObjectId, 18076882) = inMedicalProgramSPId OR COALESCE(inMedicalProgramSPId, 0) = 0 AND COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, False) = False)
                                AND (COALESCE (ObjectLink_GroupMedicalProgramSP.ChildObjectId, 0) = inGroupMedicalProgramSPId OR COALESCE(inGroupMedicalProgramSPId, 0) = 0)
                                AND COALESCE (MovementBoolean_PaperRecipeSP.ValueData,  False) = False
                              )
        ---
        , tmpMovementString_MedicSP AS (SELECT MovementString.*
                                        FROM MovementString
                                        WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement_All.Id FROM tmpMovement_All) 
                                          AND MovementString.DescId = zc_MovementString_MedicSP()
                                        )
        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_All.Id FROM tmpMovement_All) 
                                AND MovementDate.DescId IN (zc_MovementDate_OperDateSP()
                                                          , zc_MovementDate_Insert())
                              )
        , tmpMovementFloat_TotalSumm AS (SELECT MovementFloat.*
                                         FROM MovementFloat
                                         WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_All.Id FROM tmpMovement_All) 
                                           AND MovementFloat.DescId = zc_MovementFloat_TotalSumm()
                                         )
        , tmpMLO_Insert AS (SELECT MovementLinkObject.*
                            FROM MovementLinkObject
                            WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_All.Id FROM tmpMovement_All) 
                              AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                            )

        , tmpMovement AS (SELECT  Movement_Check.Id
                                , Movement_Check.OperDate
                                , Movement_Check.UnitId
                                , Movement_Check.JuridicalId
                                , Movement_Check.InvNumberSP
                                , Movement_Check.HospitalId
                                , Movement_Check.MedicalProgramSPId
                                , MovementString_MedicSP.ValueData   AS MedicSPName
                                , MovementDate_OperDateSP.ValueData  AS OperDateSP

                                , MovementFloat_TotalSumm.ValueData  AS TotalSumm_Check
                                , Object_Insert.ValueData            AS InsertName_Check
                                , MovementDate_Insert.ValueData      AS InsertDate_Check
                                , MLM_Child.MovementChildId          AS Movement_Invoice 
                          FROM tmpMovement_All AS Movement_Check
                               LEFT JOIN tmpMovementString_MedicSP AS MovementString_MedicSP
                                                                   ON MovementString_MedicSP.MovementId = Movement_Check.Id

                               LEFT JOIN tmpMovementDate AS MovementDate_OperDateSP
                                                         ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                                        AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                               LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                         ON MovementDate_Insert.MovementId = Movement_Check.Id
                                                        AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                               LEFT JOIN tmpMovementFloat_TotalSumm AS MovementFloat_TotalSumm
                                                                    ON MovementFloat_TotalSumm.MovementId = Movement_Check.Id

                               LEFT JOIN tmpMLO_Insert AS MLO_Insert
                                                       ON MLO_Insert.MovementId = Movement_Check.Id
                                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
                               LEFT JOIN MovementLinkMovement AS MLM_Child
                                      ON MLM_Child.MovementId = Movement_Check.Id
                                     AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                          )

        , tmpMovement_Invoice AS (SELECT Movement_Invoice.Id
                                       , Movement_Invoice.InvNumber                 :: TVarChar    AS InvNumber_Invoice 
                                       , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full
                                       , Movement_Invoice.OperDate                                 AS OperDate_Invoice
                                  FROM  Movement AS Movement_Invoice 
                                  WHERE Movement_Invoice.Id in (SELECT Movement_Invoice FROM tmpMovement))


        , tmpMov AS (SELECT Movement_Check.Id                                         AS Id 
                          , Movement_Check.OperDate
                          , date_trunc ('day', Movement_Check.OperDate) AS OperDate_Calc
                          , Movement_Check.UnitId
                          , Movement_Check.JuridicalId
                          , Movement_Check.InvNumberSP
                          , Movement_Check.HospitalId
                          , Movement_Check.MedicSPName
                          , Movement_Check.OperDateSP
                          , Movement_Check.MedicalProgramSPId
                          , Movement_Invoice.InvNumber_Invoice
                          , Movement_Invoice.InvNumber_Invoice_Full
                          , Movement_Invoice.OperDate_Invoice  

                          , Movement_Check.TotalSumm_Check
                          , Movement_Check.InsertName_Check
                          , Movement_Check.InsertDate_Check

                     FROM tmpMovement AS Movement_Check
                          -- счет
                          LEFT JOIN tmpMovement_Invoice AS Movement_Invoice ON Movement_Invoice.Id = Movement_Check.Movement_Invoice
                     )

        , tmpMI_Check AS (SELECT MI_Check.*
                          FROM MovementItem AS MI_Check
                          WHERE MI_Check.MovementId IN (SELECT tmpMov.Id FROM tmpMov)
                            AND MI_Check.DescId = zc_MI_Master()
                            AND MI_Check.Amount <> 0
                            AND MI_Check.isErased = FALSE
                          )
        , tmpMIC AS (SELECT DISTINCT MovementItemContainer.ContainerId, MovementItemContainer.MovementItemId
                                FROM MovementItemContainer 
                                WHERE MovementItemContainer.MovementId = 0 --IN (SELECT tmpMovement_All.Id FROM tmpMovement_All)
                                  AND MovementItemContainer.DescId = zc_MIContainer_Count())                      

        , tmpMI_CheckIncome AS (SELECT MovementItemContainer.MovementItemId AS Id
                                      ,COALESCE (MI_Income_find.Id, MI_Income.Id) AS MI_IncomeId
                                FROM tmpMIC AS MovementItemContainer 
                                      
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = MovementItemContainer.ContainerId
                                                                  AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                )
        , tmpMI_CheckPriceWithVAT AS (SELECT MI_Check.Id
                                           , Max(MIFloat_PriceWithVAT.ValueData) AS PriceWithVAT
                                      FROM tmpMI_CheckIncome AS MI_Check

                                           LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                                       ON MIFloat_PriceWithVAT.MovementItemId =  MI_Check.MI_IncomeId
                                                                      AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                      GROUP BY MI_Check.Id
                                      )
        , tmpMIFloat AS (SELECT *
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Check.Id FROM tmpMI_Check) 
                    --     AND MovementItemFloat.DescId = zc_MIFloat_SummChangePercent()
                         )

        , tmpMI AS (SELECT CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019' THEN inJuridicalMedicId ELSE 0 END AS JuridicalMedicId
                         , Movement_Check.Id      AS MovementId 
                         , Movement_Check.OperDate
                         , Movement_Check.OperDate_Calc
                         , Movement_Check.UnitId
                         , Movement_Check.JuridicalId
                         , Movement_Check.InvNumberSP
                         , Movement_Check.HospitalId
                         , Movement_Check.MedicSPName
                         , Movement_Check.OperDateSP
                         , Movement_Check.MedicalProgramSPId
                         , Movement_Check.InvNumber_Invoice
                         , Movement_Check.InvNumber_Invoice_Full
                         , Movement_Check.OperDate_Invoice

                         , Movement_Check.TotalSumm_Check
                         , Movement_Check.InsertName_Check
                         , Movement_Check.InsertDate_Check

                        , tmpGoods.GoodsMainId                                      AS GoodsMainId

                         , MAX (CASE WHEN MIFloat_SummChangePercent.ValueData < 0 THEN Movement_Check.Id ELSE 0 END) AS MovementId_err
                         , SUM (MI_Check.Amount) AS Amount
                         , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0))   AS SummChangePercent
                         , COALESCE (MIFloat_PriceSale.ValueData, 0)                 AS PriceSale
                         , MAX (CASE WHEN Movement_Check.OperDate_Calc = '01.06.2017' ::TDateTime
                                          THEN CAST (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC(16,2))
                                     ELSE 0
                                END)                                                 AS Price_calc
                         , Max(tmpMI_CheckPriceWithVAT.PriceWithVAT)                 AS PriceWithVAT  
                         , MIString_IdSP.ValueData                                   AS IdSP

                    FROM tmpMov AS Movement_Check
                         INNER JOIN tmpMI_Check AS MI_Check ON MI_Check.MovementId = Movement_Check.Id
                                                
                         LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MI_Check.ObjectId
                        --Сумма Скидки
                         LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                     ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                    AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

                         LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                     ON MIFloat_PriceSale.MovementItemId = MI_Check.Id
                                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                         LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         LEFT JOIN MovementItemString AS MIString_IdSP
                                                      ON MIString_IdSP.MovementItemId = MI_Check.Id
                                                     AND MIString_IdSP.DescId = zc_MIString_IdSP()
                                                    
                         LEFT JOIN tmpMI_CheckPriceWithVAT ON tmpMI_CheckPriceWithVAT.Id = MI_Check.Id
                         
                    GROUP BY Movement_Check.Id 
                           , Movement_Check.OperDate
                           , Movement_Check.OperDate_Calc
                           , Movement_Check.UnitId
                           , Movement_Check.JuridicalId
                           , Movement_Check.InvNumberSP
                           , Movement_Check.HospitalId
                           , Movement_Check.MedicSPName
                           , Movement_Check.OperDateSP
                           , Movement_Check.MedicalProgramSPId
                           , Movement_Check.InvNumber_Invoice
                           , Movement_Check.InvNumber_Invoice_Full
                           , Movement_Check.OperDate_Invoice
                           , tmpGoods.GoodsMainId
                           , COALESCE (MIFloat_PriceSale.ValueData, 0)
                           , CASE WHEN inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019' THEN inJuridicalMedicId ELSE 0 END
                           , Movement_Check.TotalSumm_Check
                           , Movement_Check.InsertName_Check
                           , Movement_Check.InsertDate_Check
                           , MIString_IdSP.ValueData
                    HAVING  SUM (MI_Check.Amount) <> 0
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

        , tmpParam AS (SELECT tmp.UnitId
                            , tmp.JuridicalId
                            , tmp.JuridicalMedicId
                            --, tmp.HospitalId
                           
                            , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
                            , ObjectHistory_JuridicalDetails.JuridicalAddress
                            , ObjectHistory_JuridicalDetails.OKPO
                            , ObjectHistory_JuridicalDetails.MainName
                            , ObjectHistory_JuridicalDetails.MainName_Cut
                            , ObjectHistory_JuridicalDetails.AccounterName
                            , ObjectHistory_JuridicalDetails.INN
                            , ObjectHistory_JuridicalDetails.NumberVAT
                            , ObjectHistory_JuridicalDetails.BankAccount ::TVarChar AS BankAccount  --COALESCE (Object_BankAccount.ValueData,
                            , ObjectHistory_JuridicalDetails.Phone
                            , tmpBankAccount.BankName  ::TVarChar AS BankName --COALESCE (Object_Bank.ValueData,
                            , tmpBankAccount.MFO ::TVarChar AS MFO             --COALESCE (ObjectString_MFO.ValueData, 
   
                            , ObjectHistory_PartnerMedicalDetails.FullName          AS PartnerMedical_FullName
                            , ObjectHistory_PartnerMedicalDetails.JuridicalAddress  AS PartnerMedical_JuridicalAddress
                            , ObjectHistory_PartnerMedicalDetails.OKPO              AS PartnerMedical_OKPO
                            , ObjectHistory_PartnerMedicalDetails.Phone             AS PartnerMedical_Phone
                            , ObjectHistory_PartnerMedicalDetails.MainName          AS PartnerMedical_MainName
                            , ObjectHistory_PartnerMedicalDetails.MainName_Cut      AS PartnerMedical_MainName_Cut
                            , COALESCE(Object_PartnerMedical_Contract.Id,0)         AS PartnerMedical_ContractId
                            , Object_PartnerMedical_Contract.ValueData              AS PartnerMedical_ContractName
                            , ObjectDate_Signing.ValueData                          AS PartnerMedical_Contract_SigningDate
                            , ObjectDate_Start.ValueData                            AS PartnerMedical_Contract_StartDate 
                            , ObjectDate_End.ValueData                              AS PartnerMedical_Contract_EndDate 
                            , Object_BankAccount.ValueData                          AS PartnerMedical_BankAccount
                            , Object_Bank.ValueData                                 AS PartnerMedical_BankName
                            , ObjectString_MFO.ValueData                            AS PartnerMedical_MFO

                       FROM (SELECT DISTINCT tmpMI.UnitId
                                  , tmpMI.JuridicalId
                                  --, tmpMI.HospitalId
                                  , tmpMI.JuridicalMedicId
                             FROM tmpMI) AS tmp

                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ChildObjectId = tmp.JuridicalMedicId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                              
                          LEFT JOIN Object AS Object_PartnerMedical_Contract ON Object_PartnerMedical_Contract.Id = ObjectLink_Contract_Juridical.ObjectId  

                          INNER JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_PartnerMedical_Contract.Id 
                                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                                               AND ObjectLink_Contract_JuridicalBasis.ChildObjectId = tmp.JuridicalId

                          LEFT JOIN ObjectLink AS ObjectLink_Contract_GroupMemberSP
                                               ON ObjectLink_Contract_GroupMemberSP.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectLink_Contract_GroupMemberSP.DescId = zc_ObjectLink_Contract_GroupMemberSP()
                          LEFT JOIN Object AS Object_PartnerMedical_GroupMemberSP ON Object_PartnerMedical_GroupMemberSP.Id = ObjectLink_Contract_GroupMemberSP.ChildObjectId

                          LEFT JOIN ObjectDate AS ObjectDate_Start
                                               ON ObjectDate_Start.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                          LEFT JOIN ObjectDate AS ObjectDate_End
                                               ON ObjectDate_End.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                          LEFT JOIN ObjectDate AS ObjectDate_Signing
                                               ON ObjectDate_Signing.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

                          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmp.JuridicalId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
                          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmp.JuridicalMedicId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
       
                          LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = tmp.JuridicalId
                                                  AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

                          -- расчетный счет из договора , по идее для заклада охорони здоров'я
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                                 ON ObjectLink_Contract_BankAccount.ObjectId = Object_PartnerMedical_Contract.Id
                                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
                          LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId 
                          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                               ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                              AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                          LEFT JOIN ObjectString AS ObjectString_MFO
                                                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                       WHERE COALESCE (Object_PartnerMedical_GroupMemberSP.ObjectCode,0) = -1                       
                       )

        , tmpCountR AS (SELECT  tmpData.JuridicalId
                              , tmpParam.PartnerMedical_ContractId AS ContractId
                              , COUNT ( DISTINCT tmpData.InvNumberSP_calc) AS CountInvNumberSP
                        FROM (SELECT DISTINCT tmpMI.UnitId
                                   , tmpMI.JuridicalId
                                   , tmpMI.JuridicalMedicId
                                   , tmpMI.InvNumberSP
                                   , tmpMI.OperDate
                                   , tmpMI.MedicSPName
                                   , tmpMI.OperDateSP
                                   , (tmpMI.InvNumberSP||'_'||tmpMI.MedicSPName) :: TVarChar AS InvNumberSP_calc-- составной для того чтоб посчитать кол-во рецептов, если вдруг одинаковые номера у разных врачей
                              FROM tmpMI) AS tmpData
                             LEFT JOIN tmpParam ON tmpParam.UnitId = tmpData.UnitId
                                   AND tmpParam.JuridicalId = tmpData.JuridicalId
                                   AND tmpParam.JuridicalMedicId = tmpData.JuridicalMedicId
                                   AND tmpParam.PartnerMedical_Contract_StartDate <= tmpData.OperDate AND tmpParam.PartnerMedical_Contract_EndDate >= tmpData.OperDate
                        GROUP BY tmpData.JuridicalId
                               , tmpData.JuridicalMedicId
                               , tmpParam.PartnerMedical_ContractId
                        )

        , tmpInvoice AS (SELECT MovementLinkObject_PartnerMedical.ObjectId                     AS JuridicalMedicId
                              , MovementLinkObject_Juridical.ObjectId                          AS JuridicalId
                              , SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) ::TFloat  AS TotalSumm
                         FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                              
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                           ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                              
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.OperDate >= vbStartYear AND Movement.OperDate <inEndDate
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inJuridicalMedicId OR inJuridicalMedicId = 0)
                         GROUP BY MovementLinkObject_PartnerMedical.ObjectId
                                , MovementLinkObject_Juridical.ObjectId
                         )

        , tmp_err AS (SELECT Movement_err.Id
                           , Movement_err.InvNumber
                           , Object_Unit_err.ValueData AS UnitName
                      FROM (SELECT DISTINCT tmpMI.MovementId_err FROM tmpMI) AS tt
                           LEFT JOIN Movement AS Movement_err ON Movement_err.Id = tt.MovementId_err
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_err
                                                        ON MovementLinkObject_Unit_err.MovementId = tt.MovementId_err
                                                       AND MovementLinkObject_Unit_err.DescId = zc_MovementLinkObject_Unit()
                           LEFT JOIN Object AS Object_Unit_err ON Object_Unit_err.Id = MovementLinkObject_Unit_err.ObjectId
                      )

        -- результат
        SELECT tmpData.MovementId
             , ('№ ' || Movement.InvNumber || ' от ' || Movement.OperDate  :: Date :: TVarChar )     :: TVarChar  AS InvNumber_Full
             , Object_Unit.ValueData               AS UnitName
             , Object_Juridical.Id                 AS JuridicalId
             , Object_Juridical.ValueData          AS JuridicalName

             , Object_PartnerMedical.Id            AS HospitalId
             , CASE WHEN tmpData.MovementId_err <> 0 THEN COALESCE (tmp_err.InvNumber, '' )  || ' - ' || COALESCE (tmp_err.UnitName, '') ELSE Object_PartnerMedical.ValueData END :: TVarChar AS HospitalName

             , Object_Goods_Main.ObjectCode        AS GoodsCode
             , Object_Goods_Main.Name              AS GoodsName
             , tmpGoodsSP.IntenalSPName
             , tmpGoodsSP.BrandSPName
             , tmpGoodsSP.KindOutSPName
             , tmpGoodsSP.Pack  ::TVarChar
             , tmpGoodsSP.CountSP :: TFloat 
             , tmpGoodsSP.PriceSP :: TFloat 
             , tmpGoodsSP.GroupSP :: TFloat 

             , tmpGoodsSP.CodeATX         ::TVarChar
             , tmpGoodsSP.ReestrSP        ::TVarChar
             , tmpGoodsSP.MakerSP         ::TVarChar
             , tmpGoodsSP.ReestrDateSP    ::TVarChar AS DateReestrSP
             , tmpGoodsSP.PriceOptSP      :: TFloat
             , tmpGoodsSP.PriceRetSP      :: TFloat
             , tmpGoodsSP.DailyNormSP     :: TFloat
             , tmpGoodsSP.DailyCompensationSP  :: TFloat
             , tmpGoodsSP.PaymentSP       :: TFloat
             , tmpGoodsSP.ColSP           :: TFloat
             , tmpGoodsSP.InsertDateSP    :: TDateTime
             , tmpGoodsSP.IdSP            ::TVarChar

             , tmpData.Amount            :: TFloat 
             , CAST (tmpData.PriceSale AS NUMERIC(16,2))                        :: TFloat 
             , CASE WHEN date_trunc('day', tmpData.OperDate) = ('01.06.2017' ::TDateTime)
                    THEN tmpData.Price_calc
                    ELSE CAST ((tmpData.SummChangePercent / tmpData.Amount) AS NUMERIC(16,2))
               END                                                              :: TFloat  AS PriceCheckSP
             , tmpData.PriceWithVAT :: TFloat 
             , CASE WHEN date_trunc('day', tmpData.OperDate) = ('01.06.2017' ::TDateTime)
                    THEN CAST (tmpData.Price_calc * tmpData.Amount AS NUMERIC(16,2))
                    ELSE CAST (tmpData.SummChangePercent AS NUMERIC(16,2)) 
               END                                                              :: TFloat  AS SummaSP
             , CAST (tmpData.PriceSale * tmpData.Amount AS NUMERIC(16,2))       :: TFloat  AS SummaSale
             , CAST (tmpGoodsSP.PriceSP * tmpData.Amount AS NUMERIC(16,2))      :: TFloat  AS SummaSP_pack

             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_PartnerMedical.Id/*, Object_Unit.Id*/ ORDER BY Object_PartnerMedical.ValueData, /*Object_Unit.ValueData,*/ tmpGoodsSP.IntenalSPName, tmpData.OperDate ) AS Integer) AS NumLine    --PARTITION BY Object_Juridical.ValueData
             , CAST (tmpCountR.CountInvNumberSP AS Integer) AS CountInvNumberSP

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

             , COALESCE (tmpParam.PartnerMedical_FullName, Object_PartnerMedical.ValueData) :: TVarChar AS PartnerMedical_FullName
             , tmpParam.PartnerMedical_JuridicalAddress
             , tmpParam.PartnerMedical_OKPO  ::TVarChar
             , tmpParam.PartnerMedical_Phone
             , tmpParam.PartnerMedical_BankAccount ::TVarChar
             , tmpParam.PartnerMedical_BankName ::TVarChar
             , tmpParam.PartnerMedical_MFO      ::TVarChar
             , tmpParam.PartnerMedical_MainName ::TVarChar
             , COALESCE (tmpParam.PartnerMedical_MainName_Cut, tmpParam.PartnerMedical_MainName) :: TVarChar  AS PartnerMedical_MainName_Cut
             
             , tmpParam.PartnerMedical_ContractId                                       AS ContractId
             , COALESCE (tmpParam.PartnerMedical_ContractName, '')     ::TVarChar   AS ContractName
             , (CASE WHEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) <> '01.01.2100' THEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) ELSE NULL END) :: TDateTime AS Contract_StartDate
             , CASE WHEN COALESCE (tmpParam.PartnerMedical_ContractName, '') = '' THEN NULL ELSE COALESCE (tmpParam.PartnerMedical_Contract_SigningDate, Null) END  :: TDateTime AS Contract_SigningDate

             -----
             , tmpData.JuridicalMedicId  :: Integer  AS DepartmentId
             , COALESCE (tmpParam.PartnerMedical_FullName, Object_PartnerMedical.ValueData) :: TVarChar AS Department_FullName
             , tmpParam.PartnerMedical_JuridicalAddress AS Department_JuridicalAddress
             , tmpParam.PartnerMedical_OKPO        :: TVarChar AS Department_OKPO
             , tmpParam.PartnerMedical_Phone       :: TVarChar AS Department_Phone
             , tmpParam.PartnerMedical_BankAccount :: TVarChar AS Department_BankAccount
             , tmpParam.PartnerMedical_BankName    :: TVarChar AS Department_BankName
             , tmpParam.PartnerMedical_MFO         :: TVarChar AS Department_MFO
             , tmpParam.PartnerMedical_MainName    :: TVarChar AS Department_MainName
             , COALESCE (tmpParam.PartnerMedical_MainName_Cut, tmpParam.PartnerMedical_MainName) :: TVarChar AS Department_MainName_Cut
             ,  tmpParam.PartnerMedical_ContractId   AS ContractId_Department
             , COALESCE (tmpParam.PartnerMedical_ContractName, '')     ::TVarChar  AS ContractName_Department
             , (CASE WHEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) <> '01.01.2100' THEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) ELSE NULL END) :: TDateTime AS Contract_StartDate_Department
             ,  CASE WHEN COALESCE (tmpParam.PartnerMedical_ContractName, '') = '' THEN NULL ELSE COALESCE (tmpParam.PartnerMedical_Contract_SigningDate, Null) END  :: TDateTime AS Contract_SigningDate_Department
             -----
             , tmpData.MedicSPName
             , tmpData.InvNumberSP
             , tmpData.OperDateSP
             , date_trunc('day', tmpData.OperDate)  :: TDateTime AS OperDate

             , tmpData.InvNumber_Invoice
             , tmpData.InvNumber_Invoice_Full
             , tmpData.OperDate_Invoice
             
             , tmpInvoice.TotalSumm                    :: TFloat AS TotalSumm_Invoice

             , FALSE                                             AS isPrintLast

             , tmpData.TotalSumm_Check
             , tmpData.InsertName_Check
             , tmpData.InsertDate_Check

             , ObjectFloat_NDSKind_NDS.ValueData AS NDS
             , Object_MedicalProgramSP.ValueData                            AS MedicalProgramSPName

        FROM tmpMI AS tmpData
             LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpData.JuridicalId
                                 ANd tmpInvoice.JuridicalMedicId = tmpData.JuridicalMedicId

             LEFT JOIN tmpParam ON tmpParam.UnitId      = tmpData.UnitId
                               AND tmpParam.JuridicalId = tmpData.JuridicalId
                               --AND tmpParam.HospitalId  = tmpData.HospitalId
                               AND tmpParam.PartnerMedical_Contract_StartDate <= tmpData.OperDate AND tmpParam.PartnerMedical_Contract_EndDate >= tmpData.OperDate
 
             LEFT JOIN tmpCountR ON tmpCountR.JuridicalId = tmpData.JuridicalId
                               -- AND tmpCountR.HospitalId = tmpData.HospitalId
                                AND COALESCE (tmpCountR.ContractId,0) = COALESCE (tmpParam.PartnerMedical_ContractId,0)

             LEFT JOIN tmpGoodsSP AS tmpGoodsSP 
                                  ON tmpGoodsSP.GoodsMainId = tmpData.GoodsMainId
                                 AND DATE_TRUNC('DAY', tmpData.OperDate ::TDateTime) >= tmpGoodsSP.OperDateStart
                                 AND DATE_TRUNC('DAY', tmpData.OperDate ::TDateTime) <= tmpGoodsSP.OperDateEnd
                                 AND tmpGoodsSP.MedicalProgramSPId = tmpData.MedicalProgramSPId
                                 AND (tmpGoodsSP.IdSP = tmpData.IdSP OR COALESCE(tmpData.IdSP, '') = '')
                                 

             LEFT JOIN tmp_err ON tmp_err.Id = tmpData.MovementId_err

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId and Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId and Object_Juridical.DescId = zc_Object_Juridical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.JuridicalMedicId and Object_PartnerMedical.DescId = zc_Object_PartnerMedical()

             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = tmpData.GoodsMainId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

             LEFT JOIN Movement ON Movement.Id = tmpData.MovementId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                          ON MovementLinkObject_MedicalProgramSP.MovementId = tmpData.MovementId
                                         AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
             LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MovementLinkObject_MedicalProgramSP.ObjectId

        ORDER BY Object_Unit.ValueData 
               , Object_Juridical.ValueData
               , tmpGoodsSP.IntenalSPName
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 26.04.19         * юр.лицо плательщик один с 01,04,2019
*/

-- тест  select * from gpReport_Check_SP_01042019(inStartDate := ('01.03.2021')::TDateTime , inEndDate := ('15.03.2021')::TDateTime , inJuridicalId := 2886776 , inUnitId := 0 , inHospitalId := 0 , inJuridicalMedicId := 10959824 ,  inSession := '3');


select * from gpReport_Check_SP(inStartDate := ('04.04.2023')::TDateTime , inEndDate := ('30.04.2023')::TDateTime , inJuridicalId := 1311462 , inUnitId := 0 , inHospitalId := 0 , inJuridicalMedicId := 10959824 , inMedicalProgramSPId := 0 , inGroupMedicalProgramSPId := 0 ,  inSession := '3');

