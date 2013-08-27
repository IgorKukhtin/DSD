-- Function: gpComplete_Movement_Cash()

-- DROP FUNCTION gpComplete_Movement_Cash(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Cash(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
  RETURNS void AS
$BODY$
  DECLARE vbSumm TFloat;
  DECLARE vbOperDate TDateTime;
  DECLARE vbFromId Integer;
  DECLARE vbToId Integer;
  DECLARE vbFromDescId Integer;
  DECLARE vbToDescId Integer;
  DECLARE vbInfoMoneyId Integer;
  DECLARE vbContractId Integer;

  DECLARE vbMainJuridicalId Integer;
  DECLARE vbBusinessId Integer;
  DECLARE vbCashId Integer;
  DECLARE vbInfoMoneyGroupId Integer;
  DECLARE vbInfoMoneyDestinationId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbObjectDescId Integer;
  DECLARE vbAccountId Integer;
  DECLARE vbAccountGroupId Integer;
  DECLARE vbAccountDirectionId Integer;
  DECLARE vbUserId Integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
     vbUserId := 2; -- CAST (inSession AS Integer);

   -- определяем свойства документа. 
      SELECT OperDate 
           , Object_From.Id 
           , Object_To.Id
           , Object_From.DescId
           , Object_To.DescId
           , MovementLinkObject_InfoMoney.ObjectId
           , MovementFloat_Amount.ValueData
           , Object_InfoMoney.InfoMoneyGroupId 
           , Object_InfoMoney.InfoMoneyDestinationId
           , MovementLinkObject_Contract.ObjectId
             INTO vbOperDate, vbFromId, vbToId, vbFromDescId, vbToDescId, vbInfoMoneyId, 
                  vbSumm, vbInfoMoneyGroupId, vbInfoMoneyDestinationId, vbContractId
        FROM Movement 
   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
          ON MovementLinkObject_From.MovementId = Movement.Id
         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
          ON MovementLinkObject_To.MovementId = Movement.Id
         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
   LEFT JOIN MovementFloat AS MovementFloat_Amount 
          ON MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
         AND MovementFloat_Amount.MovementId = Movement.Id
   LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
          ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
         AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
          ON MovementLinkObject_Contract.MovementId = Movement.Id
         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
   
   LEFT JOIN lfGet_Object_InfoMoney(MovementLinkObject_InfoMoney.ObjectId) AS Object_InfoMoney ON 1=1
   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

   WHERE Movement.Id = inMovementId;

   -- Проверки
   IF COALESCE (vbFromDescId, 0) = zc_Object_Cash()  
   THEN
      vbCashId := vbFromId;
      vbObjectId := vbToId;  
      vbObjectDescId := vbToDescId;
   ELSE 
      IF COALESCE (vbToDescId, 0) = zc_Object_Cash()
      THEN
        vbCashId := vbToId;
        vbObjectId := vbFromId;
        vbObjectDescId := vbFromDescId;
      ELSE 
         RAISE EXCEPTION 'В документе не определена касса. Проведение невозможно';
      END IF;
   END IF;
   
   -- Вытягиваем у кассы Юрлицо и Бизнес
   SELECT 
      Cash_MainJuridical.ChildObjectId INTO vbMainJuridicalId
   FROM ObjectLink AS Cash_MainJuridical
  WHERE Cash_MainJuridical.ObjectId = vbCashId AND Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical();

   IF COALESCE (vbMainJuridicalId, 0) = 0 
   THEN
     RAISE EXCEPTION 'У кассы не установлено главное юр лицо. Проведение невозможно';
   END IF;

   SELECT 
      Cash_Business.ChildObjectId INTO vbBusinessId
   FROM ObjectLink AS Cash_Business
  WHERE Cash_Business.ObjectId = vbCashId AND Cash_Business.DescId = zc_ObjectLink_Cash_Business();

   IF COALESCE (vbBusinessId, 0) = 0 
   THEN
     RAISE EXCEPTION 'У кассы не установлен бизнес. Проведение невозможно';
   END IF;

   -- Если мы платим
   IF vbCashId = vbFromId 
   THEN
       -- Определяем счета по управленческим операциям
       CASE vbObjectDescId 
            -- Юр. лицо
            WHEN zc_Object_Juridical() THEN
                 -- Выбираем по управленческой статье
                 SELECT outAccountGroupId, outAccountDirectionId INTO vbAccountGroupId, vbAccountDirectionId FROM lfGet_Object_AccountForJuridical(vbInfoMoneyDestinationId, true);
            -- Сотрудник
            WHEN zc_Object_Personal() THEN
                 -- Выбираем по управленческой статье
                 CASE vbInfoMoneyDestinationId  
                       WHEN zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
                       THEN
                            vbAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                            vbAccountDirectionId := zc_Enum_AccountDirection_70600(); -- сотрудники (заготовители);
                       WHEN zc_Enum_InfoMoneyDestination_60100() -- Заработная плата
                       THEN
                            vbAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                            vbAccountDirectionId := zc_Enum_AccountDirection_70500(); -- Заработная плата;
                 END CASE;
       END CASE;
   ELSE -- Нам платят
       CASE vbObjectDescId 
            -- Юр. лицо
            WHEN zc_Object_Juridical() THEN
                 -- Выбираем по управленческой статье
                 SELECT outAccountGroupId, outAccountDirectionId INTO vbAccountGroupId, vbAccountDirectionId FROM lfGet_Object_AccountForJuridical(vbInfoMoneyDestinationId, true);
            -- Сотрудник
            WHEN zc_Object_Personal() THEN
                 -- Выбираем по управленческой статье
                 CASE vbInfoMoneyDestinationId  
                       WHEN zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_10200(),
                            zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(),
                            zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_20600(),
                            zc_Enum_InfoMoneyDestination_20700()
                       THEN
                            vbAccountGroupId := zc_Enum_AccountGroup_30000(); -- Дебиторы;
                            vbAccountDirectionId := zc_Enum_AccountDirection_30500(); -- сотрудники (подотчетные лица)
                       WHEN zc_Enum_InfoMoneyDestination_60100() -- Заработная плата
                       THEN
                            vbAccountGroupId := zc_Enum_AccountGroup_70000(); -- Кредиторы;
                            vbAccountDirectionId := zc_Enum_AccountDirection_70500(); -- Заработная плата;
                 END CASE;
       END CASE;
   END IF;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := vbAccountGroupId
                                             , inAccountDirectionId     := vbAccountDirectionId
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := vbUserId
                                               );
                                                                                                      

   -- таблица - Аналитики остатка
   CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;

   -- формируются Проводки для суммового учета по кассе
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MIContainer_Summ()
                                               , inMovementId:= inMovementId
                                               , inMovementItemId:= NULL
                                               , inParentId:= NULL
                                               , inContainerId:=  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 
                                                                 lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                       , inParentId:= NULL
                                                                                       , inObjectId:= zc_Enum_Account_40101()
                                                                                       , inJuridicalId_basis:= vbMainJuridicalId
                                                                                       , inBusinessId       := vbBusinessId
                                                                                       , inObjectCostDescId := NULL
                                                                                       , inObjectCostId     := NULL
                                                                                       , inDescId_1   := zc_ContainerLinkObject_Cash()
                                                                                       , inObjectId_1 := vbCashId
                                                                                         )
                                                , inAmount:= - vbSumm
                                                , inOperDate:= vbOperDate
                                                , inIsActive:= (vbCashId = vbToId));

   -- формируются Проводки не по кассе
     -- формируются Проводки - долг Поставщику или Сотруднику (подотчетные лица)
     PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                 , inDescId:= zc_MIContainer_Summ()
                                                 , inMovementId:= inMovementId
                                                 , inMovementItemId:= NULL
                                                 , inParentId:= NULL
                                                 , inContainerId:=   -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                                                                   lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                         , inParentId:= NULL
                                                                                         , inObjectId:= vbAccountId
                                                                                         , inJuridicalId_basis:= vbMainJuridicalId
                                                                                         , inBusinessId       := vbBusinessId
                                                                                         , inObjectCostDescId := NULL
                                                                                         , inObjectCostId     := NULL
                                                                                         , inDescId_1   := zc_ContainerLinkObject_Juridical()
                                                                                         , inObjectId_1 := vbObjectId
                                                                                         , inDescId_2   := zc_ContainerLinkObject_PaidKind()
                                                                                         , inObjectId_2 := zc_Enum_PaidKind_SecondForm()
                                                                                         , inDescId_3   := zc_ContainerLinkObject_Contract()
                                                                                         , inObjectId_3 := COALESCE(vbContractId, 0)
                                                                                         , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                         , inObjectId_4 := vbInfoMoneyId
                                                                                        )
                                                 , inAmount:= vbSumm
                                                 , inOperDate:= vbOperDate
                                                 , inIsActive:= (vbCashId = vbFromId)
                                                  );



  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 13.08.13                        *                
*/
