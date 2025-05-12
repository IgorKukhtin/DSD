-- View: _bi_Guide_Member_View

 DROP VIEW IF EXISTS _bi_Guide_Member_View;

-- Справочник Фмз.лица
CREATE OR REPLACE VIEW _bi_Guide_Member_View
AS
WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.PositionLevelId
                                , lfSelect.BranchId
                                , lfSelect.DateIn
                                , lfSelect.DateOut
                                , lfSelect.isDateOut
                                , lfSelect.Ord
                           FROM lfSelect_Object_Member_findPersonal (zfCalc_UserAdmin()) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )


       SELECT
             Object_Member.Id         AS Id
           , Object_Member.ObjectCode AS Code
           , Object_Member.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_Member.isErased   AS isErased

         --Код 1С
         , ObjectString_Code1C.ValueData ::TVarChar AS Code1C
         --ИНН
         , ObjectString_INN.ValueData               AS INN
         --Водительское удостоверение
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         --№ карточного счета ЗП - первая форма
         , ObjectString_Card.ValueData              AS Card
         --№ карточного счета ЗП - Ф2(Восток)
         , ObjectString_CardSecond.ValueData        AS CardSecond
         --№ карточного счета ЗП - алименты (удержание)
         , ObjectString_CardChild.ValueData         AS CardChild
         --№ карточного счета IBAN ЗП - первая форма
         , ObjectString_CardIBAN.ValueData          AS CardIBAN
         --№ карточного IBANсчета ЗП - Ф2(Восток)
         , ObjectString_CardIBANSecond.ValueData    AS CardIBANSecond
         --Номер банковской карточки ЗП Ф1
         , ObjectString_CardBank.ValueData          AS CardBank
         --Номер банковской карточки ЗП - Ф2(Восток)
         , ObjectString_CardBankSecond.ValueData    AS CardBankSecond 
         --Номер банковской карточки ЗП - Ф2(ОТП)    
         , ObjectString_CardBankSecondTwo.ValueData    AS CardBankSecondTwo
         --№ карточного IBANсчета ЗП - Ф2(ОТП)
         , ObjectString_CardIBANSecondTwo.ValueData    AS CardIBANSecondTwo
         --№ карточного счета ЗП - Ф2(ОТП) 
         , ObjectString_CardSecondTwo.ValueData        AS CardSecondTwo
         --Номер банковской карточки ЗП - Ф2(личный)
         , ObjectString_CardBankSecondDiff.ValueData   AS CardBankSecondDiff
         --№ карточного IBANсчета ЗП - Ф2(личный)
         , ObjectString_CardIBANSecondDiff.ValueData   AS CardIBANSecondDiff
         --№ карточного счета ЗП - Ф2(личный) 
         , ObjectString_CardSecondDiff.ValueData       AS CardSecondDiff
         --Примечание    
         , ObjectString_Comment.ValueData              AS Comment

         --Исключить из компенсации отпуска
         , COALESCE (ObjectBoolean_NotCompensation.ValueData, FALSE) :: Boolean  AS isNotCompensation
         --Bank - ЗП Ф1
         , Object_Bank.Id               AS BankId
         , Object_Bank.ValueData        AS BankName
         --Bank - Ф2(Восток)
         , Object_BankSecond.Id         AS BankSecondId
         , Object_BankSecond.ValueData  AS BankSecondName
         --Bank - алименты (удержание)
         , Object_BankChild.Id          AS BankChildId
         , Object_BankChild.ValueData   AS BankChildName
         --Bank - Ф2(ОТП)
         , Object_BankSecondTwo.Id          AS BankSecondTwoId
         , Object_BankSecondTwo.ValueData   AS BankSecondTwoName
         --Bank - Ф2(личный)
         , Object_BankSecondDiff.Id         AS BankSecondDiffId
         , Object_BankSecondDiff.ValueData  AS BankSecondDiffName
         --Статьи назначения
         , Object_InfoMoney_View.InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all
         -- начальная дата для нормы авто лето
         , COALESCE(ObjectDate_StartSummer.ValueData, Null)  ::TDateTime  AS StartSummerDate
         --Конечная дата для нормы авто лето
         , COALESCE(ObjectDate_EndSummer.ValueData, Null)    ::TDateTime  AS EndSummerDate
         --норма авто литры лето
         , COALESCE(ObjectFloat_SummerFuel.ValueData, 0) ::TFloat  AS SummerFuel
         --норма авто литры зима
         , COALESCE(ObjectFloat_WinterFuel.ValueData, 0) ::TFloat  AS WinterFuel
         --амортизация за 1 км., грн.
         , COALESCE(ObjectFloat_Reparation.ValueData, 0) ::TFloat  AS Reparation
         --лимит грн
         , COALESCE(ObjectFloat_Limit.ValueData, 0)         ::TFloat   AS LimitMoney
         --лимит км
         , COALESCE(ObjectFloat_LimitDistance.ValueData, 0) ::TFloat   AS LimitDistance

         --информативно по главному месту - Филиал
         , Object_Branch.Id           AS BranchId
         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName
         --информативно по главному месту - подразделение
         , Object_Unit.Id             AS UnitId
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName 
         --информативно по главному месту - должность
         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName 
         --информативно по главному месту - разряд
         , Object_PositionLevel.Id         AS PositionLevelId
         , Object_PositionLevel.ObjectCode AS PositionLevelCode
         , Object_PositionLevel.ValueData  AS PositionLevelName
         --информативно по главному месту - уволен Да/нет
         , tmpPersonal.isDateOut :: Boolean AS isDateOut
         --информативно по главному месту - дата принятия
         , tmpPersonal.DateIn
         --информативно по главному месту - дата увольнения
         , tmpPersonal.DateOut
         --информативно по главному месту - Сотрудник
         , tmpPersonal.PersonalId
         
         
         --Подразделение(заявки мобильный)
         , Object_UnitMobile.Id         AS UnitMobileId
         , Object_UnitMobile.ObjectCode AS UnitMobileCode
         , Object_UnitMobile.ValueData  AS UnitMobileName

         ----Сотрудники/ Подразделения/Учредители  - На кого "переносятся" затраты в "Налоги с ЗП" или в "Мобильная связь" 
         , ObjectTo.Id                AS ObjectToId
         , ObjectTo.ValueData         AS ObjectToName
         , ObjectDesc.ItemName        AS DescName

         --Пол
         , Object_Gender.Id              AS GenderId
         , Object_Gender.ValueData       AS GenderName
         --Квалификация 
         , Object_MemberSkill.Id         AS MemberSkillId
         , Object_MemberSkill.ValueData  AS MemberSkillName
         --Источник информации о вакансии
         , Object_JobSource.Id           AS JobSourceId
         , Object_JobSource.ValueData    AS JobSourceName 
         --Область, адрес прописки
         , Object_Region.Id              AS RegionId
         , Object_Region.ValueData       AS RegionName
         --Область, адрес проживания
         , Object_Region_Real.Id         AS RegionId_Real
         , Object_Region_Real.ValueData  AS RegionName_Real
         --Город/село/пгт, адрес прописки
         , Object_City.Id                AS CityId
         , Object_City.ValueData         AS CityName
         --Город/село/пгт, адрес проживания
         , Object_City_Real.Id           AS CityId_Real
         , Object_City_Real.ValueData    AS CityName_Real
         --Улица, номер дома, номер квартиры, адрес прописки
         , ObjectString_Street.ValueData               AS Street
         , ObjectString_Street_Real.ValueData          AS Street_Real

         --Маршрутка
         , Object_RouteNum.Id            AS RouteNumId
         , Object_RouteNum.ValueData     AS RouteNumName
         --Паспорт, дата рождения
         , COALESCE(ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
         --Ребенок 1, дата рождения
         , COALESCE(ObjectDate_Children1.ValueData, Null)  ::TDateTime  AS Children1_Date
         --Ребенок 2, дата рождения
         , COALESCE(ObjectDate_Children2.ValueData, Null)  ::TDateTime  AS Children2_Date
         --Ребенок 3, дата рождения
         , COALESCE(ObjectDate_Children3.ValueData, Null)  ::TDateTime  AS Children3_Date
         --Ребенок 4, дата рождения
         , COALESCE(ObjectDate_Children4.ValueData, Null)  ::TDateTime  AS Children4_Date
         --Ребенок 5, дата рождения
         , COALESCE(ObjectDate_Children5.ValueData, Null)  ::TDateTime  AS Children5_Date
         --Паспорт, срок годности с
         , COALESCE(ObjectDate_PSP_Start.ValueData, Null)  ::TDateTime  AS PSP_StartDate
         --Паспорт, срок годности по
         , COALESCE(ObjectDate_PSP_End.ValueData, Null)    ::TDateTime  AS PSP_EndDate
         --Декрет с
         , COALESCE(ObjectDate_Dekret_Start.ValueData, Null)  ::TDateTime  AS Dekret_StartDate
         --Декрет по
         , COALESCE(ObjectDate_Dekret_End.ValueData, Null)    ::TDateTime  AS Dekret_EndDate
         --Ребенок 1, ФИО
         , ObjectString_Children1.ValueData            AS Children1
         --Ребенок 2, ФИО
         , ObjectString_Children2.ValueData            AS Children2
         --Ребенок 3, ФИО
         , ObjectString_Children3.ValueData            AS Children3
         --Ребенок 4, ФИО
         , ObjectString_Children4.ValueData            AS Children4
         --Ребенок 5, ФИО
         , ObjectString_Children5.ValueData            AS Children5
         --Судимости
         , ObjectString_Law.ValueData                  AS Law
         --Водительское удостоверение для вождения кары и т.п.
         , ObjectString_DriverCertificateAdd.ValueData AS DriverCertificateAdd
         --Паспорт, серия
         , ObjectString_PSP_S.ValueData                AS PSP_S
         --Паспорт, номер
         , ObjectString_PSP_N.ValueData                AS PSP_N
         --Паспорт, кем выдан
         , ObjectString_PSP_W.ValueData                AS PSP_W
         --Паспорт, дата выдачи
         , ObjectString_PSP_D.ValueData                AS PSP_D
         --GLN
         , ObjectString_GLN.ValueData      :: TVarChar AS GLN  
         --E-Mail
         , ObjectString_EMail.ValueData    :: TVarChar AS EMail
         --Phone
         , ObjectString_Phone.ValueData    :: TVarChar AS Phone
     FROM Object AS Object_Member
          --Исключить из компенсации отпуска
          LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCompensation
                                  ON ObjectBoolean_NotCompensation.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_NotCompensation.DescId = zc_ObjectBoolean_Member_NotCompensation()
          --ИНН
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = Object_Member.Id
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
          --№ карточного счета ЗП - первая форма
          LEFT JOIN ObjectString AS ObjectString_Card
                                 ON ObjectString_Card.ObjectId = Object_Member.Id
                                AND ObjectString_Card.DescId = zc_ObjectString_Member_Card()
          --№ карточного счета ЗП - Ф2(Восток)
          LEFT JOIN ObjectString AS ObjectString_CardSecond
                                 ON ObjectString_CardSecond.ObjectId = Object_Member.Id
                                AND ObjectString_CardSecond.DescId = zc_ObjectString_Member_CardSecond()
          --№ карточного счета ЗП - алименты (удержание)
          LEFT JOIN ObjectString AS ObjectString_CardChild
                                 ON ObjectString_CardChild.ObjectId = Object_Member.Id
                                AND ObjectString_CardChild.DescId = zc_ObjectString_Member_CardChild()
          --№ карточного счета IBAN ЗП - первая форма
          LEFT JOIN ObjectString AS ObjectString_CardIBAN
                                 ON ObjectString_CardIBAN.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
          --№ карточного IBANсчета ЗП - Ф2(Восток)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecond
                                 ON ObjectString_CardIBANSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()
          --Номер банковской карточки ЗП Ф1
          LEFT JOIN ObjectString AS ObjectString_CardBank
                                 ON ObjectString_CardBank.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBank.DescId = zc_ObjectString_Member_CardBank()
          --Номер банковской карточки ЗП - Ф2(Восток)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                 ON ObjectString_CardBankSecond.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()
          --Водительское удостоверение
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()
          --Номер банковской карточки ЗП - Ф2(ОТП)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecondTwo
                                 ON ObjectString_CardBankSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondTwo.DescId = zc_ObjectString_Member_CardBankSecondTwo()
          --№ карточного IBANсчета ЗП - Ф2(ОТП)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondTwo
                                 ON ObjectString_CardIBANSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondTwo.DescId = zc_ObjectString_Member_CardIBANSecondTwo()
          LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                 ON ObjectString_CardSecondTwo.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondTwo.DescId = zc_ObjectString_Member_CardSecondTwo()
          --Номер банковской карточки ЗП - Ф2(личный)
          LEFT JOIN ObjectString AS ObjectString_CardBankSecondDiff
                                 ON ObjectString_CardBankSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardBankSecondDiff.DescId = zc_ObjectString_Member_CardBankSecondDiff()
          --№ карточного IBANсчета ЗП - Ф2(личный)
          LEFT JOIN ObjectString AS ObjectString_CardIBANSecondDiff
                                 ON ObjectString_CardIBANSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardIBANSecondDiff.DescId = zc_ObjectString_Member_CardIBANSecondDiff()
          --№ карточного счета ЗП - Ф2(личный) 
          LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                 ON ObjectString_CardSecondDiff.ObjectId = Object_Member.Id 
                                AND ObjectString_CardSecondDiff.DescId = zc_ObjectString_Member_CardSecondDiff()
          --Код 1С
          LEFT JOIN ObjectString AS ObjectString_Code1C
                                 ON ObjectString_Code1C.ObjectId = Object_Member.Id
                                AND ObjectString_Code1C.DescId = zc_ObjectString_Member_Code1C()
          --Примечание
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Member.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment() 
          --E-Mail
          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Member.Id
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()

         --Статьи назначения
         LEFT JOIN ObjectLink AS ObjectLink_Member_InfoMoney
                              ON ObjectLink_Member_InfoMoney.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_InfoMoney.DescId = zc_ObjectLink_Member_InfoMoney()
         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Member_InfoMoney.ChildObjectId
         --Сотрудники/ Подразделения/Учредители  - На кого "переносятся" затраты в "Налоги с ЗП" или в "Мобильная связь" 
         LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo
                              ON ObjectLink_Member_ObjectTo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
         LEFT JOIN Object AS ObjectTo ON ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = ObjectTo.DescId
         --Пол
         LEFT JOIN ObjectLink AS ObjectLink_Member_Gender
                              ON ObjectLink_Member_Gender.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Gender.DescId = zc_ObjectLink_Member_Gender()
         LEFT JOIN Object AS Object_Gender ON Object_Gender.Id = ObjectLink_Member_Gender.ChildObjectId
         --Квалификация
         LEFT JOIN ObjectLink AS ObjectLink_Member_MemberSkill
                              ON ObjectLink_Member_MemberSkill.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_MemberSkill.DescId = zc_ObjectLink_Member_MemberSkill()
         LEFT JOIN Object AS Object_MemberSkill ON Object_MemberSkill.Id = ObjectLink_Member_MemberSkill.ChildObjectId
         --Источник информации о вакансии
         LEFT JOIN ObjectLink AS ObjectLink_Member_JobSource
                              ON ObjectLink_Member_JobSource.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_JobSource.DescId = zc_ObjectLink_Member_JobSource()
         LEFT JOIN Object AS Object_JobSource ON Object_JobSource.Id = ObjectLink_Member_JobSource.ChildObjectId
         --Область, адрес прописки
         LEFT JOIN ObjectLink AS ObjectLink_Member_Region
                              ON ObjectLink_Member_Region.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region.DescId = zc_ObjectLink_Member_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_Member_Region.ChildObjectId
         --Город/село/пгт, адрес прописки
         LEFT JOIN ObjectLink AS ObjectLink_Member_City
                              ON ObjectLink_Member_City.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City.DescId = zc_ObjectLink_Member_City()
         LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Member_City.ChildObjectId
         ----Область, адрес проживания
         LEFT JOIN ObjectLink AS ObjectLink_Member_Region_Real
                              ON ObjectLink_Member_Region_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Region_Real.DescId = zc_ObjectLink_Member_Region_Real()
         LEFT JOIN Object AS Object_Region_Real ON Object_Region_Real.Id = ObjectLink_Member_Region_Real.ChildObjectId
         --Город/село/пгт, адрес проживания
         LEFT JOIN ObjectLink AS ObjectLink_Member_City_Real
                              ON ObjectLink_Member_City_Real.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_City_Real.DescId = zc_ObjectLink_Member_City_Real()
         LEFT JOIN Object AS Object_City_Real ON Object_City_Real.Id = ObjectLink_Member_City_Real.ChildObjectId
         --Маршрутка
         LEFT JOIN ObjectLink AS ObjectLink_Member_RouteNum
                              ON ObjectLink_Member_RouteNum.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_RouteNum.DescId = zc_ObjectLink_Member_RouteNum()
         LEFT JOIN Object AS Object_RouteNum ON Object_RouteNum.Id = ObjectLink_Member_RouteNum.ChildObjectId
         -- начальная дата для нормы авто лето
         LEFT JOIN ObjectDate AS ObjectDate_StartSummer
                              ON ObjectDate_StartSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_StartSummer.DescId = zc_ObjectDate_Member_StartSummer()
         --Конечная дата для нормы авто лето
         LEFT JOIN ObjectDate AS ObjectDate_EndSummer
                              ON ObjectDate_EndSummer.ObjectId = Object_Member.Id
                             AND ObjectDate_EndSummer.DescId = zc_ObjectDate_Member_EndSummer()
         --Паспорт, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Birthday
                              ON ObjectDate_Birthday.ObjectId = Object_Member.Id
                             AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()
         --Ребенок 1, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Children1
                              ON ObjectDate_Children1.ObjectId = Object_Member.Id
                             AND ObjectDate_Children1.DescId = zc_ObjectDate_Member_Children1()
         --Ребенок 2, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Children2
                              ON ObjectDate_Children2.ObjectId = Object_Member.Id
                             AND ObjectDate_Children2.DescId = zc_ObjectDate_Member_Children2()
         --Ребенок 3, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Children3
                              ON ObjectDate_Children3.ObjectId = Object_Member.Id
                             AND ObjectDate_Children3.DescId = zc_ObjectDate_Member_Children3()
         --Ребенок 4, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Children4
                              ON ObjectDate_Children4.ObjectId = Object_Member.Id
                             AND ObjectDate_Children4.DescId = zc_ObjectDate_Member_Children4()
         --Ребенок 5, дата рождения
         LEFT JOIN ObjectDate AS ObjectDate_Children5
                              ON ObjectDate_Children5.ObjectId = Object_Member.Id
                             AND ObjectDate_Children5.DescId = zc_ObjectDate_Member_Children5()
         --Паспорт, срок годности с
         LEFT JOIN ObjectDate AS ObjectDate_PSP_Start
                              ON ObjectDate_PSP_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_Start.DescId = zc_ObjectDate_Member_PSP_Start()
         --Паспорт, срок годности по
         LEFT JOIN ObjectDate AS ObjectDate_PSP_End
                              ON ObjectDate_PSP_End.ObjectId = Object_Member.Id
                             AND ObjectDate_PSP_End.DescId = zc_ObjectDate_Member_PSP_End()
         --Декрет с
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_Start
                              ON ObjectDate_Dekret_Start.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_Start.DescId = zc_ObjectDate_Member_Dekret_Start()
         --Декрет по 
         LEFT JOIN ObjectDate AS ObjectDate_Dekret_End
                              ON ObjectDate_Dekret_End.ObjectId = Object_Member.Id
                             AND ObjectDate_Dekret_End.DescId = zc_ObjectDate_Member_Dekret_End()
         --Улица, номер дома, номер квартиры, адрес прописки
         LEFT JOIN ObjectString AS ObjectString_Street
                                ON ObjectString_Street.ObjectId = Object_Member.Id
                               AND ObjectString_Street.DescId = zc_ObjectString_Member_Street()
         --Улица, номер дома, номер квартиры, адрес проживания
         LEFT JOIN ObjectString AS ObjectString_Street_Real
                                ON ObjectString_Street_Real.ObjectId = Object_Member.Id
                               AND ObjectString_Street_Real.DescId = zc_ObjectString_Member_Street_Real()
         --Ребенок 1, ФИО
         LEFT JOIN ObjectString AS ObjectString_Children1
                                ON ObjectString_Children1.ObjectId = Object_Member.Id
                               AND ObjectString_Children1.DescId = zc_ObjectString_Member_Children1()
         --Ребенок 2, ФИО
         LEFT JOIN ObjectString AS ObjectString_Children2
                                ON ObjectString_Children2.ObjectId = Object_Member.Id
                               AND ObjectString_Children2.DescId = zc_ObjectString_Member_Children2()
         --Ребенок 3, ФИО
         LEFT JOIN ObjectString AS ObjectString_Children3
                                ON ObjectString_Children3.ObjectId = Object_Member.Id
                               AND ObjectString_Children3.DescId = zc_ObjectString_Member_Children3()
         --Ребенок 4, ФИО
         LEFT JOIN ObjectString AS ObjectString_Children4
                                ON ObjectString_Children4.ObjectId = Object_Member.Id
                               AND ObjectString_Children4.DescId = zc_ObjectString_Member_Children4()
         --Ребенок 5, ФИО
         LEFT JOIN ObjectString AS ObjectString_Children5
                                ON ObjectString_Children5.ObjectId = Object_Member.Id
                               AND ObjectString_Children5.DescId = zc_ObjectString_Member_Children5()
         --Судимости
         LEFT JOIN ObjectString AS ObjectString_Law
                                ON ObjectString_Law.ObjectId = Object_Member.Id
                               AND ObjectString_Law.DescId = zc_ObjectString_Member_Law()
         --Водительское удостоверение для вождения кары и т.п.
         LEFT JOIN ObjectString AS ObjectString_DriverCertificateAdd
                                ON ObjectString_DriverCertificateAdd.ObjectId = Object_Member.Id
                               AND ObjectString_DriverCertificateAdd.DescId = zc_ObjectString_Member_DriverCertificateAdd()
         --Паспорт, серия
         LEFT JOIN ObjectString AS ObjectString_PSP_S
                                ON ObjectString_PSP_S.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_S.DescId = zc_ObjectString_Member_PSP_S()
         --Паспорт, номер
         LEFT JOIN ObjectString AS ObjectString_PSP_N
                                ON ObjectString_PSP_N.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_N.DescId = zc_ObjectString_Member_PSP_N()
         --Паспорт, кем выдан
         LEFT JOIN ObjectString AS ObjectString_PSP_W
                                ON ObjectString_PSP_W.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_W.DescId = zc_ObjectString_Member_PSP_W()
         --Паспорт, дата выдачи
         LEFT JOIN ObjectString AS ObjectString_PSP_D
                                ON ObjectString_PSP_D.ObjectId = Object_Member.Id
                               AND ObjectString_PSP_D.DescId = zc_ObjectString_Member_PSP_D()
         --Код GLN
         LEFT JOIN ObjectString AS ObjectString_GLN
                                ON ObjectString_GLN.ObjectId = Object_Member.Id
                               AND ObjectString_GLN.DescId = zc_ObjectString_Member_GLN()
         --Phone
         LEFT JOIN ObjectString AS ObjectString_Phone
                                ON ObjectString_Phone.ObjectId = Object_Member.Id
                               AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()
         --норма авто литры лето
         LEFT JOIN ObjectFloat AS ObjectFloat_SummerFuel
                               ON ObjectFloat_SummerFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_SummerFuel.DescId = zc_ObjectFloat_Member_Summer()
         --норма авто литры зима
         LEFT JOIN ObjectFloat AS ObjectFloat_WinterFuel
                               ON ObjectFloat_WinterFuel.ObjectId = Object_Member.Id
                              AND ObjectFloat_WinterFuel.DescId = zc_ObjectFloat_Member_Winter()
         --амортизация за 1 км., грн.
         LEFT JOIN ObjectFloat AS ObjectFloat_Reparation
                               ON ObjectFloat_Reparation.ObjectId = Object_Member.Id
                              AND ObjectFloat_Reparation.DescId = zc_ObjectFloat_Member_Reparation()
         --лимит грн
         LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                               ON ObjectFloat_Limit.ObjectId = Object_Member.Id
                              AND ObjectFloat_Limit.DescId = zc_ObjectFloat_Member_Limit()
         -- лимит км
         LEFT JOIN ObjectFloat AS ObjectFloat_LimitDistance
                               ON ObjectFloat_LimitDistance.ObjectId = Object_Member.Id
                              AND ObjectFloat_LimitDistance.DescId = zc_ObjectFloat_Member_LimitDistance()
         --Bank - ЗП Ф1
         LEFT JOIN ObjectLink AS ObjectLink_Member_Bank
                              ON ObjectLink_Member_Bank.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Bank.DescId = zc_ObjectLink_Member_Bank()
         LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Member_Bank.ChildObjectId
         --Bank - Ф2(Восток)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                              ON ObjectLink_Member_BankSecond.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecond.DescId = zc_ObjectLink_Member_BankSecond()
         LEFT JOIN Object AS Object_BankSecond ON Object_BankSecond.Id = ObjectLink_Member_BankSecond.ChildObjectId
         --Bank - алименты (удержание)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankChild
                              ON ObjectLink_Member_BankChild.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankChild.DescId = zc_ObjectLink_Member_BankChild()
         LEFT JOIN Object AS Object_BankChild ON Object_BankChild.Id = ObjectLink_Member_BankChild.ChildObjectId
         --Bank - Ф2(ОТП)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                              ON ObjectLink_Member_BankSecondTwo.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondTwo.DescId = zc_ObjectLink_Member_BankSecondTwo()
         LEFT JOIN Object AS Object_BankSecondTwo ON Object_BankSecondTwo.Id = ObjectLink_Member_BankSecondTwo.ChildObjectId
         --Bank - Ф2(личный)
         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                              ON ObjectLink_Member_BankSecondDiff.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_BankSecondDiff.DescId = zc_ObjectLink_Member_BankSecondDiff()
         LEFT JOIN Object AS Object_BankSecondDiff ON Object_BankSecondDiff.Id = ObjectLink_Member_BankSecondDiff.ChildObjectId
         --Подразделение(заявки мобильный)
         LEFT JOIN ObjectLink AS ObjectLink_Member_UnitMobile
                              ON ObjectLink_Member_UnitMobile.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_UnitMobile.DescId = zc_ObjectLink_Member_UnitMobile()
         LEFT JOIN Object AS Object_UnitMobile ON Object_UnitMobile.Id = ObjectLink_Member_UnitMobile.ChildObjectId

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id AND tmpPersonal.Ord = 1
         LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
         LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpPersonal.PositionLevelId

       WHERE Object_Member.DescId = zc_Object_Member()
      ;

ALTER TABLE _bi_Guide_Member_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.25         * all
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Member_View
