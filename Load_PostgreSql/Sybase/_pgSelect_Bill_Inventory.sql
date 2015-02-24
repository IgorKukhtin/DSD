alter PROCEDURE "DBA"."_pgSelect_Bill_Inventory" (in @inIsGlobalLoad smallint, in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, InvNumber TVarCharLong, OperDate Date, FromId_Postgres Integer, ToId_Postgres Integer, isCar smallint, Id_Postgres Integer)
begin
  -- 
  declare local temporary table _tmpList_Unit(
  UnitId integer not null,
  primary key(UnitId),
  ) on commit delete rows;
  -- 
  declare local temporary table _tmpList(
       BillId Integer
     , UnitId Integer
  ) on commit preserve rows;
  //
  -- !!!!!!
  set @inIsGlobalLoad=zc_rvNo();
  //
  //
  -- !!!start @inIsGlobalLoad!!!
  if @inIsGlobalLoad=zc_rvYes()
  then
      raiserror 21000 '@inIsGlobalLoad=zc_rvYes()';
      --
      select (_pgCar.Id) as ObjectId
           , (_pgCar.Id) as InvNumber
           , @inEndDate as OperDate
           , _pgCar.CarId_pg as FromId_Postgres
           , _pgCar.CarId_pg as ToId_Postgres
           , zc_rvYes() as isCar
           , (_pgCar.MovementId_pg) as Id_Postgres
      from dba._pgCar
      where @inEndDate = '2013-09-30'
        and isnull(_pgCar.MovementId_pg,0)=0
      order by 3, 1;
      --!!!
      return;
  end if;
  -- !!!end @inIsGlobalLoad!!!
  //
  // 
  -- Unit
  insert into _tmpList_Unit (UnitId)
     select (Unit.Id) as UnitId -- max (Unit.Id) as UnitId
     from dba.Unit
          left outer join dba.isUnit on isUnit.UnitId = Unit.Id
          left outer join dba._pgUnit on _pgUnit.Id = Unit.pgUnitId -- and isnull(Unit.ParentId,0) <> 4137 -- MO
          left outer join dba._pgPersonal on _pgPersonal.Id = Unit.PersonalId_Postgres -- and Unit.ParentId = 4137 -- MO
          -- left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = _pgUnit.Id or Unit_find.PersonalId_Postgres = _pgPersonal.Id
     where (isUnit.UnitId is not null
            or (/*@inEndDate < '2014-06-01' and */(Unit.ParentId = 4137 or Unit.ParentId = 8217)) -- MO + АВТОМОБИЛИ
           )
       -- and Unit.Id <> 2791 -- Склад УТИЛЬ
       and Unit.Id <> 2324 -- Склад С/К
       and Unit.Id <> 2612 -- Склад-автомат-пересортица
       and Unit.Id <> 2827 -- Цех Упаковки (брак)
       and Unit.Id <> 2826 -- Цех Упаковки (переработка)
     -- group by Unit_find.pgUnitId, Unit_find.PersonalId_Postgres, isnull (Unit_find.pgUnitId,isnull (Unit_find.PersonalId_Postgres, Unit.Id))
    ;

  -- insert exists Bill 
  insert into _tmpList (BillId, UnitId)
    select isnull (Bill.Id, 0) as BillId
         , _tmpList_Unit.UnitId
    from _tmpList_Unit
         left outer join dba.Bill on Bill.FromId = _tmpList_Unit.UnitId
                                 and Bill.BillDate = @inEndDate
                                 and Bill.BillKind in (zc_bkProductionInFromReceipt())
                                 and Bill.isRemains = zc_rvYes()
    ;

  -- check
  if exists (select BillId from _tmpList where BillId <> 0 group by BillId having count()>1)
  then raiserror 21000 'check';
  end if;


  -- Create Bill
  insert into dba.Bill (BillDate, BillNumber, BillKind, FromID, ToID, Nds, IsNds, MoneyKindID, DiscountFromOperCount, DiscountTax, IsChangeDolg, IsCalculateProduction, isByMinusDiscountTax, BillSummIn, BillSumm, BillSummOperCount, isRemains, Id_Postgres) 
     select @inEndDate, 0, zc_bkProductionInFromReceipt(), UnitId, UnitId, 0 as Nds, zc_rvUn() as IsNds, zc_mkNal() as MoneyKindID, 0 as DiscountFromOperCount, 0 as DiscountTax, zc_rvUn() as IsChangeDolg, zc_rvUn() as IsCalculateProduction, zc_rvUn() as isByMinusDiscountTax, 0, 0, 0, zc_rvYes() as isRemains, 0 as Id_Postgres
     from _tmpList
     where BillId = 0;

    // 
    -- result
    select (Bill.Id) as ObjectId
         , (Bill.BillNumber) || case when pgUnitFrom.Id is null and pgPersonalFrom.Id is null then '-ошибка '|| UnitFrom.UnitName else '' /*'-'||UnitFrom.UnitName*/ end as InvNumber
         , @inEndDate as OperDate
         , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
         , FromId_Postgres as ToId_Postgres
         , zc_rvNo() as isCar
         , (Bill.Id_Postgres) as Id_Postgres
    from dba.Bill
         inner join _tmpList_Unit on _tmpList_Unit.UnitId = Bill.FromId
         left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
         left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
                                                  -- and UnitFrom.ParentId <> 4137 -- MO
         left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                                                          -- and UnitFrom.ParentId = 4137 -- MO
    where Bill.BillDate = @inEndDate
      and Bill.BillKind in (zc_bkProductionInFromReceipt())
      and Bill.isRemains = zc_rvYes()
    order by 3, 1
   ;

end
//
-- call dba._pgSelect_Bill_Inventory (zc_rvNo(), '2014-05-01', '2014-05-31')