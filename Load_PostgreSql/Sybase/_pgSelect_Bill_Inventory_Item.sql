alter PROCEDURE "DBA"."_pgSelect_Bill_Inventory_Item" (in @inIsGlobalLoad smallint, in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, MovementId Integer, BillNumber TVarCharShort, BillDate Date, myUnitId Integer, GoodsPropertyId Integer, GoodsId Integer, Amount TSumm, PartionGoodsDate date, Price TSumm, Summ TSumm, HeadCount TSumm, myCount TSumm, PartionGoods TVarCharMedium, GoodsKindId Integer, AssetId Integer, UnitId Integer, StorageId Integer, isCar smallint, InfoMoneyCode Integer, Id_Postgres Integer)
begin
  --
  declare @saveRemains smallint;
  //
  --
  declare local temporary table _tmp1_opt(
  GoodsPropertyId integer not null,
  UnitId integer not null,
  ) on commit delete rows;
  --
  declare local temporary table _tmp2_opt(
  GoodsPropertyId integer not null,
  UnitId integer not null,
  BillDate Date
  ) on commit delete rows;
  --
  declare local temporary table _tmp21_opt(
  GoodsPropertyId integer not null,
  UnitId integer not null,
  PartionDate date 
  ) on commit delete rows;
  --
  //
  --
  declare local temporary table _tmpList_Partion_find(
  UnitId integer not null,
  GoodsPropertyId integer not null,
  BillItemsId integer not null,
  ) on commit delete rows;
  --
  --
  declare local temporary table _tmpList_Remains_byKindPackage(
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionDate date not null,
  StartCount TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionDate),
  ) on commit delete rows;
  --
  declare local temporary table _tmpList_Remains_byKindPackage_two(
  Id integer NOT NULL DEFAULT autoincrement,
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionDate date not null,
  StartCount TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionDate),
  ) on commit preserve rows;
  --
  //
  --
  declare local temporary table _tmpList_Remains_byPartionStr(
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionStr_MB TVarCharMedium not null,
  StartCount TSumm not null,
  StartCount_sh TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndCount_sh TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionStr_MB),
  ) on commit delete rows;
  --
  declare local temporary table _tmpList_Remains_byPartionStr_two(
  Id integer NOT NULL DEFAULT autoincrement,
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionStr_MB TVarCharMedium not null,
  StartCount TSumm not null,
  StartCount_sh TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndCount_sh TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionStr_MB),
  ) on commit preserve rows;
  //
  //
  //
  //
  declare local temporary table _tmpList_Bill(
  UnitId integer not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;
  --
  /*declare local temporary table _tmpList_Bill_find(
  UnitId integer not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;*/
  //
  -- by Calc ALL remains
  declare local temporary table _tmpList_Unit(
  UnitId integer not null,
  isPartionDate smallint not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;
  //
  -- by PartionStr
  declare local temporary table _tmpList_GoodsProperty_isPartion(
  GoodsPropertyId integer not null,
  primary key(GoodsPropertyId),
  ) on commit delete rows;
  -- by remains PartionStr
  declare local temporary table _tmpList_GoodsProperty_isPartionStr_calcRemains(
  GoodsPropertyId integer not null,
  primary key(GoodsPropertyId),
  ) on commit delete rows;
  //
  //
  -- !!!!!!
  set @inIsGlobalLoad=zc_rvNo();
  //
  -- !!!start @inIsGlobalLoad!!!
  if @inIsGlobalLoad=zc_rvYes()
  then
      raiserror 21000 '@inIsGlobalLoad=zc_rvYes()';
      --
      select 0 as ObjectId
           , _pgCar.MovementId_pg as MovementId
           , _pgCar.Name as BillNumber
           , @inEndDate as OperDate
           , _pgCar.Id as UnitId
           , tmpFuel.Id_Postgres_Fuel as GoodsId
           , isnull(case when tmpFuel.Id_Postgres_Fuel = Goods_7003.Id_Postgres_Fuel then _pgCar.a11
                         when tmpFuel.Id_Postgres_Fuel = Goods_7001.Id_Postgres_Fuel then _pgCar.a21
                         when tmpFuel.Id_Postgres_Fuel = Goods_7004.Id_Postgres_Fuel then _pgCar.a31
                         when tmpFuel.Id_Postgres_Fuel = Goods_7005.Id_Postgres_Fuel then _pgCar.a41
             end, 0) as Amount
           , null as PartionGoodsDate
           , isnull(case when tmpFuel.Id_Postgres_Fuel = Goods_7003.Id_Postgres_Fuel then _pgCar.a12
                         when tmpFuel.Id_Postgres_Fuel = Goods_7001.Id_Postgres_Fuel then _pgCar.a22
                         when tmpFuel.Id_Postgres_Fuel = Goods_7004.Id_Postgres_Fuel then _pgCar.a32
                         when tmpFuel.Id_Postgres_Fuel = Goods_7005.Id_Postgres_Fuel then _pgCar.a42
             end, 0) as Summ
           , 0 as HeadCount
           , 0 as myCount
           , '' as PartionGoods
           , 0 as GoodsKindId
           , 0 as AssetId
           , zc_rvYes() as isCar
           , 0 as Id_Postgres
      from (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005
           ) as tmpFuel
           left join _pgCar on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001)as Goods_7001 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003)as Goods_7003 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004)as Goods_7004 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005)as Goods_7005 on 1=1
      where @inEndDate = '2013-09-30'
        and Amount <> 0 or Summ <> 0
      order by 3, 6;
      --!!!
      return;
  end if;
  -- !!!end @inIsGlobalLoad!!!
  //
  // 
  //
  -- !!! create List Unit - 1 !!! 
  insert into _tmpList_Unit (UnitId, isPartionDate)
    select Unit.Id, isnull (isUnit.isPartionDate, zc_rvNo())
    from dba.Unit
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
         -- left outer join dba._pgUnit on _pgUnit.Id = Unit.pgUnitId
         -- left outer join dba._pgPersonal on _pgPersonal.Id = Unit.PersonalId_Postgres
         -- left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = _pgUnit.Id or Unit_find.PersonalId_Postgres = _pgPersonal.Id
    where (isUnit.UnitId is not null
           or (/*@inEndDate < '2014-06-01' and*/ (Unit.ParentId = 4137 or Unit.ParentId = 8217)) -- MO + ¿¬“ŒÃŒ¡»À»
          )
      and Unit.Id not in (zc_UnitId_StoreReturnBrak(), zc_UnitId_StoreReturn(), zc_UnitId_StoreReturnUtil())
      -- and Unit.Id <> 2791 -- —ÍÎ‡‰ ”“»À‹
      and Unit.Id <> 2324 -- —ÍÎ‡‰ —/ 
      and Unit.Id <> 2612 -- —ÍÎ‡‰-‡‚ÚÓÏ‡Ú-ÔÂÂÒÓÚËˆ‡
      and Unit.Id <> 2827 -- ÷Âı ”Ô‡ÍÓ‚ÍË (·‡Í)
      and Unit.Id <> 2826 -- ÷Âı ”Ô‡ÍÓ‚ÍË (ÔÂÂ‡·ÓÚÍ‡)
    group by Unit.Id, isUnit.isPartionDate
--      and Unit.ParentId in (4188)
-- and 1=0
    ;
  -- !!! add List Unit - 2 !!! 
/*  insert into _tmpList_Unit (BillId, UnitId, isPartionDate)
    select isnull(_tmp.BillId, 0), isnull (Unit.Id, 0), isnull (isUnit.isPartionDate, zc_rvNo())
    from dba._pgPersonal
         join dba.Unit on Unit.PersonalId_Postgres = _pgPersonal.Id
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
         left outer join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id
         left outer join (select BillId, _pgPersonal.Id from dba._pgPersonal join dba.Unit on Unit.PersonalId_Postgres = _pgPersonal.Id join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id) as _tmp on _tmp.Id = _pgPersonal.Id
    where _tmpList_Unit.UnitId is null
   union all
    select isnull(_tmp.BillId, 0), isnull (Unit.Id, 0), isnull (isUnit.isPartionDate, zc_rvNo())
    from dba._pgUnit
         join dba.Unit on Unit.pgUnitId = _pgUnit.Id
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
         left outer join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id
         left outer join (select BillId, _pgUnit.Id from dba._pgUnit join dba.Unit on Unit.pgUnitId = _pgUnit.Id join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id) as _tmp on _tmp.Id = _pgUnit.Id
    where _tmpList_Unit.UnitId is null*/;
  //
  //
  --
      -- delete
      delete from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB;
      -- Create List GoodsProperty isPartion
      insert into _tmpList_GoodsProperty_isPartion (GoodsPropertyId)
        select GoodsPropertyID from dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO_PG AS _toolsView_GoodsProperty_Obvalka_isPartionStr_MB;
      -- Create List Goods
      insert into _tmpList_GoodsProperty_isPartionStr_calcRemains (GoodsPropertyId)
        select GoodsPropertyID from _tmpList_GoodsProperty_isPartion;


   -- !!!!!!!!!!!!!
   set @saveRemains = zc_rvYes();
   -- set @saveRemains = zc_rvNo();
   -- !!!!!!!!!!!!!

   if @saveRemains = zc_rvYes()
   then 
    print '-----@saveRemains = zc_rvYes()';

    -- 1.1. calc remains only by PartionStr
    call dba.pInsert_ReportRemainsAll_byKindPackage_onPartionStr (@inEndDate, @inEndDate);
    --
    insert into _tmpList_Remains_byPartionStr_two (UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn)
       select UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn
       from _tmpList_Remains_byPartionStr
       where fCheckUnitClientParentID (4178, UnitID) = zc_rvYes(); -- — À¿ƒ Ãﬂ—ÕŒ√Œ —€–‹ﬂ
      
    -- 1.2
    update _tmpList_Remains_byPartionStr_two set EndSummIn = EndCount * newPrice
    from
      (select GoodsPropertyId, PartionStr_MB, EndSummIn / EndCount as newPrice
       from (select GoodsPropertyId, PartionStr_MB, SUM (_tmpList_Remains_byPartionStr_two.EndCount) as EndCount, SUM (_tmpList_Remains_byPartionStr_two.EndSummIn) as EndSummIn
             from _tmpList_Remains_byPartionStr_two
             group by GoodsPropertyId, PartionStr_MB
             having SUM (_tmpList_Remains_byPartionStr_two.EndCount) > 0
            ) as tmp
      ) as tmp
    where tmp.GoodsPropertyId = _tmpList_Remains_byPartionStr_two.GoodsPropertyId
      and tmp.PartionStr_MB = _tmpList_Remains_byPartionStr_two.PartionStr_MB
    ;

    -- 1.3
    update _tmpList_Remains_byPartionStr_two set _tmpList_Remains_byPartionStr_two.EndSummIn = _tmpList_Remains_byPartionStr_two.EndSummIn + _tmpList_Remains_byPartionStr_two.EndCount / tmp2.EndCount * tmp.EndSummIn
    from (select tmp.GoodsPropertyId, SUM (tmp.EndSummIn) as EndSummIn
          from (select Id, GoodsPropertyId, PartionStr_MB, _tmpList_Remains_byPartionStr_two.EndSummIn
                from _tmpList_Remains_byPartionStr_two
                where _tmpList_Remains_byPartionStr_two.EndCount = 0
               ) as tmp
               left join _tmpList_Remains_byPartionStr_two on _tmpList_Remains_byPartionStr_two.GoodsPropertyId = tmp.GoodsPropertyId
                                                          and _tmpList_Remains_byPartionStr_two.PartionStr_MB = tmp.PartionStr_MB
                                                          and _tmpList_Remains_byPartionStr_two.EndCount <> 0 
          where _tmpList_Remains_byPartionStr_two.GoodsPropertyId is null
          group by tmp.GoodsPropertyId
         ) as tmp
         join (select GoodsPropertyId, sum (_tmpList_Remains_byPartionStr_two.EndCount) as EndCount
               from _tmpList_Remains_byPartionStr_two
               where _tmpList_Remains_byPartionStr_two.EndCount > 0
               group by GoodsPropertyId
              ) as tmp2 on tmp2.GoodsPropertyId = tmp.GoodsPropertyId
    where _tmpList_Remains_byPartionStr_two.GoodsPropertyId = tmp.GoodsPropertyId
      and _tmpList_Remains_byPartionStr_two.EndCount > 0;

    -- 1.4
    delete from _tmpList_Remains_byPartionStr_two 
    where Id in (select tmp.Id
                 from (select Id, GoodsPropertyId, PartionStr_MB, _tmpList_Remains_byPartionStr_two.EndSummIn
                       from _tmpList_Remains_byPartionStr_two
                       where _tmpList_Remains_byPartionStr_two.EndCount = 0
                      ) as tmp
                      left join _tmpList_Remains_byPartionStr_two on _tmpList_Remains_byPartionStr_two.GoodsPropertyId = tmp.GoodsPropertyId
                                                                 and _tmpList_Remains_byPartionStr_two.PartionStr_MB = tmp.PartionStr_MB
                                                                 and _tmpList_Remains_byPartionStr_two.EndCount <> 0 
                     join (select GoodsPropertyId, sum (_tmpList_Remains_byPartionStr_two.EndCount) as EndCount
                           from _tmpList_Remains_byPartionStr_two
                           where _tmpList_Remains_byPartionStr_two.EndCount > 0
                           group by GoodsPropertyId
                          ) as tmp2 on tmp2.GoodsPropertyId = tmp.GoodsPropertyId
                 where _tmpList_Remains_byPartionStr_two.GoodsPropertyId is null
                )
   ;

    //
    //
    -- 2.1. calc remains by all
    call dba.pInsert_ReportRemainsAll_byKindPackage_onSumm (@inEndDate, @inEndDate);
    -- 
    insert into _tmpList_Remains_byKindPackage_two (UnitId,GoodsPropertyId,KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn)
       select UnitId, _tmpList_Remains_byKindPackage.GoodsPropertyId, KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn
       from _tmpList_Remains_byKindPackage
            LEFT JOIN _tmpList_GoodsProperty_isPartionStr_calcRemains ON _tmpList_GoodsProperty_isPartionStr_calcRemains.GoodsPropertyId = _tmpList_Remains_byKindPackage.GoodsPropertyId
       where _tmpList_GoodsProperty_isPartionStr_calcRemains.GoodsPropertyId IS NULL
          OR fCheckUnitClientParentID (4178, UnitID) = zc_rvNo(); -- — À¿ƒ Ãﬂ—ÕŒ√Œ —€–‹ﬂ;


    -- 2.2. my delete - error
    delete from _tmpList_Remains_byKindPackage_two where GoodsPropertyId = 4165 and UnitId = 1325 ; -- —‚ËÌËÌ‡ Ì/Í (Ú‡ÌÁËÚÌ‡ˇ) + ÷Âı ”Ô‡ÍÓ‚ÍË

    //
    -- 2.3.1. my delete 
    delete from _tmpList_Remains_byKindPackage_two where Id in (select Id
                                                                from _tmpList_Remains_byKindPackage_two
                                                                 join (select GoodsPropertyId, KindPackageId, PartionDate from _tmpList_Remains_byKindPackage_two where EndCount = 0 group by GoodsPropertyId, KindPackageId, PartionDate having abs (sum (EndSummIn)) <= 0.1
                                                                      ) as tmp on tmp.GoodsPropertyId = _tmpList_Remains_byKindPackage_two.GoodsPropertyId
                                                                              and tmp.KindPackageId = _tmpList_Remains_byKindPackage_two.KindPackageId
                                                                              and tmp.PartionDate = _tmpList_Remains_byKindPackage_two.PartionDate
                                                                where EndCount = 0);
    -- 2.3.2. move summ on EndCount =0
    update _tmpList_Remains_byKindPackage_two

       set _tmpList_Remains_byKindPackage_two.StartCount = _tmpList_Remains_byKindPackage_two.StartCount   + tmpFind.StartCount
         , _tmpList_Remains_byKindPackage_two.StartSummIn = _tmpList_Remains_byKindPackage_two.StartSummIn + tmpFind.StartSummIn
         , _tmpList_Remains_byKindPackage_two.EndCount = _tmpList_Remains_byKindPackage_two.EndCount       + 0
         , _tmpList_Remains_byKindPackage_two.EndSummIn = _tmpList_Remains_byKindPackage_two.EndSummIn     + tmpFind.EndSummIn
    from (select max (_tmpList_Remains_byKindPackage_two.Id) as Id, tmp.GoodsPropertyId, tmp.KindPackageId, tmp.PartionDate
          from (select max (_tmpList_Remains_byKindPackage_two.EndCount) as EndCount, GoodsPropertyId, KindPackageId, PartionDate
                from _tmpList_Remains_byKindPackage_two
                where _tmpList_Remains_byKindPackage_two.EndCount <> 0
                group by GoodsPropertyId, KindPackageId, PartionDate
               ) as tmp
               join _tmpList_Remains_byKindPackage_two on _tmpList_Remains_byKindPackage_two.GoodsPropertyId = tmp.GoodsPropertyId
                                                 and _tmpList_Remains_byKindPackage_two.KindPackageId = tmp.KindPackageId
                                                 and _tmpList_Remains_byKindPackage_two.PartionDate = tmp.PartionDate
                                                 and _tmpList_Remains_byKindPackage_two.EndCount = tmp.EndCount
          group by tmp.GoodsPropertyId, tmp.KindPackageId, tmp.PartionDate
         ) as tmp
         join (select sum (_tmpList_Remains_byKindPackage_two.EndSummIn) as EndSummIn, sum (_tmpList_Remains_byKindPackage_two.StartCount) as StartCount, sum (_tmpList_Remains_byKindPackage_two.StartCount) as StartSummIn
                    , GoodsPropertyId, KindPackageId, PartionDate
               from _tmpList_Remains_byKindPackage_two
               where EndCount = 0
               group by GoodsPropertyId, KindPackageId, PartionDate
              ) as tmpFind on tmpFind.GoodsPropertyId = tmp.GoodsPropertyId
                          and tmpFind.KindPackageId = tmp.KindPackageId
                          and tmpFind.PartionDate = tmp.PartionDate
    where _tmpList_Remains_byKindPackage_two.Id = tmp.Id;

    -- 2.3.3. delete summ on EndCount =0
    delete from _tmpList_Remains_byKindPackage_two where Id in (select Id
                                                                from _tmpList_Remains_byKindPackage_two
                                                                 join (select GoodsPropertyId, KindPackageId, PartionDate from _tmpList_Remains_byKindPackage_two where EndCount <> 0 group by GoodsPropertyId, KindPackageId, PartionDate
                                                                      ) as tmp on tmp.GoodsPropertyId = _tmpList_Remains_byKindPackage_two.GoodsPropertyId
                                                                              and tmp.KindPackageId = _tmpList_Remains_byKindPackage_two.KindPackageId
                                                                              and tmp.PartionDate = _tmpList_Remains_byKindPackage_two.PartionDate
                                                                where EndCount = 0);
    -- 2.3.4. my delete
    delete from _tmpList_Remains_byKindPackage_two where abs (EndCount) <= 0.01 and abs (EndSummIn) <= 0.01;
    //
    //
    -- 3.1. save Remains
    delete from dba.tmpReport_RecalcOperation_Remains;
    insert into dba.tmpReport_RecalcOperation_Remains (UnitId,GoodsPropertyId,KindPackageId, PartionDate, StartCount,StartSummIn,EndCount,EndSummIn)
      select UnitId, GoodsPropertyId, KindPackageId,PartionDate, StartCount,StartSummIn,EndCount,EndSummIn from _tmpList_Remains_byKindPackage_two;
    -- 3.2. save Remains by PartionStr
    delete from dba.tmpReport_RecalcOperation_Remains_byPartionStr;
    insert into dba.tmpReport_RecalcOperation_Remains_byPartionStr (UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn)
      select UnitId, GoodsPropertyId, KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn from _tmpList_Remains_byPartionStr_two;

   else
     -- restore remains no PartionStr
     insert into _tmpList_Remains_byKindPackage_two (UnitId,GoodsPropertyId,KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn)
        select UnitId, GoodsPropertyId, KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn from dba.tmpReport_RecalcOperation_Remains;
     -- restore remains only by PartionStr
     insert into _tmpList_Remains_byPartionStr_two (UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn)
        select UnitId, GoodsPropertyId, KindPackageId, PartionStr_MB, StartCount, 0 as StartCount_sh, StartSummIn, EndCount, 0 as EndCount_sh, EndSummIn from dba.tmpReport_RecalcOperation_Remains_byPartionStr;
   end if;



  -- 2.1.1. insert into _tmp1_opt
  print '2.1.1. insert into _tmp1_opt';
  insert into _tmp1_opt (GoodsPropertyId, UnitId)
      select GoodsProperty.Id as GoodsPropertyId, _tmpList_Remains_byKindPackage_two.UnitId
      from dba.GoodsProperty
           inner join _tmpList_Remains_byKindPackage_two on _tmpList_Remains_byKindPackage_two.GoodsPropertyId = GoodsProperty.Id
      where GoodsProperty.InfoMoneyCode in (20201, 20202, 20203, 20204, 20205, 20206, 20207,    20301, 20302, 20303, 20304, 20305, 20306, 20307,   70101, 70102, 70103, 70104, 70105)
      group by GoodsProperty.Id, _tmpList_Remains_byKindPackage_two.UnitId;
  -- 2.1.2. insert into _tmp2_opt
  print '2.1.2. insert into _tmp2_opt';
  insert into _tmp2_opt (GoodsPropertyId, UnitId, BillDate)
          select GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId, max (Bill.BillDate) as BillDate
          from _tmp1_opt as GoodsProperty
                join dba.Bill on Bill.ToId = GoodsProperty.UnitId
                             -- and Bill.FromId in (zc_UnitId_Composition(), zc_UnitId_CompositionZ())
                             and Bill.BillKind = zc_bkSendUnitToUnit()
                join dba.BillItems on BillItems.BillId = Bill.Id
                                  and BillItems.GoodsPropertyId = GoodsProperty.GoodsPropertyId
                                  -- and BillItems.BillKind = zc_bkSendUnitToUnit()
                                  and BillItems.OperCount <> 0
          group by GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId;

    // 
    -- 2.1.3. Calculate PartionDate - TM÷ and ÃÕÃ¿
    print '2.1.3. Calculate PartionDate - TM÷ and ÃÕÃ¿';
    update _tmpList_Remains_byKindPackage_two
          set _tmpList_Remains_byKindPackage_two.PartionDate = GoodsProperty.BillDate
    from dba.Unit, _tmp2_opt as GoodsProperty
     where _tmpList_Remains_byKindPackage_two.UnitId = Unit.Id and Unit.ParentId in (4137, 8217) -- MO + ¿¬“ŒÃŒ¡»À»
       and _tmpList_Remains_byKindPackage_two.GoodsPropertyId = GoodsProperty.GoodsPropertyId
       and _tmpList_Remains_byKindPackage_two.UnitId = GoodsProperty.UnitId;

    -- 2.2.1. insert into _tmp21_opt
    print '2.2.1. insert into _tmp21_opt';
    insert into _tmp21_opt (GoodsPropertyId, UnitId, PartionDate)
                                select GoodsProperty.Id as GoodsPropertyId, _tmpList_Remains_byKindPackage_two.UnitId, max (isnull(_tmpList_Remains_byKindPackage_two.PartionDate,zc_DateEnd())) as PartionDate
                                from dba.GoodsProperty
                                     inner join _tmpList_Remains_byKindPackage_two on _tmpList_Remains_byKindPackage_two.GoodsPropertyId = GoodsProperty.Id
                                     inner join dba.Unit on Unit.Id = _tmpList_Remains_byKindPackage_two.UnitId
                                                        and Unit.ParentId in (4137, 8217) -- MO + ¿¬“ŒÃŒ¡»À»
                                where GoodsProperty.InfoMoneyCode in (20201, 20202, 20203, 20204, 20205, 20206, 20207,    20301, 20302, 20303, 20304, 20305, 20306, 20307,   70101, 70102, 70103, 70104, 70105)
                                group by GoodsProperty.Id, _tmpList_Remains_byKindPackage_two.UnitId;
    -- 2.2.2. Calculate Partion - TM÷ and ÃÕÃ¿
    print '2.2.2. Calculate Partion - TM÷ and ÃÕÃ¿';
    insert into _tmpList_Partion_find (GoodsPropertyId, UnitId, BillItemsId)
                          select GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId, max (BillItems.Id) as BillItemsId
                           from _tmp21_opt as GoodsProperty
                                join dba.Bill on Bill.BillDate <= GoodsProperty.PartionDate
                                             and Bill.BillKind = zc_bkIncomeToUnit()
                                join dba.BillItems on BillItems.BillId = Bill.Id
                                                  and BillItems.GoodsPropertyId = GoodsProperty.GoodsPropertyId
                                                  -- and BillItems.BillKind = zc_bkIncomeToUnit()
                                                  and BillItems.OperCount <>0
                                                  and BillItems.OperPrice <>0
                          group by GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId;
    // 
    -- 3.1. find exists isRemains = zc_rvYes
    print '3.1. find exists isRemains = zc_rvYes';
    insert into _tmpList_Bill (BillId, UnitId) -- _tmpList_Bill_find (BillId, UnitId)
                          select max (Bill.Id) as BillId, Bill.FromId as UnitId -- Unit_find.Id as UnitId
                          from dba.Bill
                               -- left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                               -- left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
                               -- left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                               --                                                  and pgPersonalFrom.Id_Postgres > 0
                               -- left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = pgUnitFrom.Id or Unit_find.PersonalId_Postgres = pgPersonalFrom.Id
                          where Bill.BillDate = @inEndDate
                            and Bill.BillKind in (zc_bkProductionInFromReceipt())
                            and Bill.isRemains = zc_rvYes()
                            and Bill.Id_Postgres <> 0
                          group by UnitId;
    -- 3.2. find exists isRemains = zc_rvYes
    /*insert into _tmpList_Bill (UnitId, BillId)
    select _tmpList_Remains_byKindPackage_two.UnitId, _tmp.BillId
    from (select UnitId from _tmpList_Remains_byKindPackage_two group by UnitId) as _tmpList_Remains_byKindPackage_two
         join dba.Unit on Unit.Id = _tmpList_Remains_byKindPackage_two.UnitId
         left outer join (select max (Unit.Id) as UnitId_find, isnull (Unit_find.pgUnitId,isnull (-Unit_find.PersonalId_Postgres, Unit.Id)) as myId
                          from dba.Unit
                               left outer join dba.isUnit on isUnit.UnitId = Unit.Id
                               left outer join dba._pgUnit on _pgUnit.Id = Unit.pgUnitId and isnull(Unit.ParentId,0) <> 4137 -- MO
                               left outer join dba._pgPersonal on _pgPersonal.Id = Unit.PersonalId_Postgres and Unit.ParentId = 4137 -- MO
                               left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = _pgUnit.Id or Unit_find.PersonalId_Postgres = _pgPersonal.Id
                          where isUnit.UnitId is not null or Unit.ParentId = 4137 -- MO
                          group by Unit_find.pgUnitId, Unit_find.PersonalId_Postgres, isnull (Unit_find.pgUnitId,isnull (-Unit_find.PersonalId_Postgres, Unit.Id))
                         ) as tmpUnit on myId = case when Unit.ParentId = 4137 then isnull(-Unit.PersonalId_Postgres,Unit.Id)
                                                     else isnull(Unit.pgUnitId,Unit.Id)
                                                end
         left outer join _tmpList_Bill_find as _tmp on _tmp.UnitId = tmpUnit.UnitId_find
     where _tmp.BillId <>0;*/


    print '----------- Start Finish';
    // 
    -- result
    select 0 as ObjectId
         , Bill.Id_Postgres as MovementId
         , Bill.BillNumber
         , Bill.BillDate
         , _tmpList_Remains_byKindPackage_two.UnitId as myUnitId
         , GoodsProperty.Id          as GoodsPropertyId
         , GoodsProperty.Id_Postgres as GoodsId
         , sum (EndCount) as Amount
         , _tmpList_Remains_byKindPackage_two.PartionDate as PartionGoodsDate
         , case when BI_find.OperCount > 0 then BI_find.SummIn / BI_find.OperCount else 0 end as Price
         , sum (case when (Goods.ParentId = 686 and @inEndDate >= '2013-01-01')
                        or GoodsProperty.InfoMoneyCode in (20501) -- Œ·ÓÓÚÌ‡ˇ Ú‡‡
                                                     /*not in (10101 -- ÃˇÒÌÓÂ Ò˚¸Â
                                                              ,10102 -- 
                                                              ,10103 -- 
                                                              ,10104 -- 
                                                              ,10105 -- 
                                                              ,10201 -- œÓ˜ÂÂ Ò˚¸Â
                                                              ,10202 -- 
                                                              ,10203 -- 
                                                              ,10204 -- 
                                                              ,20601 -- œÓ˜ËÂ Ï‡ÚÂË‡Î˚
                                                              ,30101 -- œÓ‰ÛÍˆËˇ
                                                              ,30102 --
                                                              ,30103 --
                                                              ,30301 -- œÂÂ‡·ÓÚÍ‡
                                                              )*/
                          then 0 else EndSummIn end) as Summ
         , 0 as HeadCount
         , 0 as myCount
         , _tmpList_Remains_byKindPackage_two.PartionStr_MB as PartionGoods
         , KindPackage.Id_Postgres as GoodsKindId
         , 0 as AssetId
         , _pgCar.CarId_pg as UnitId
         , 0 as StorageId
         , zc_rvNo() as isCar
         , GoodsProperty.InfoMoneyCode
         , 0 as Id_Postgres
    from (select UnitId, GoodsPropertyId, KindPackageId,PartionDate, '' as PartionStr_MB, StartCount,StartSummIn,EndCount,EndSummIn
          from _tmpList_Remains_byKindPackage_two
         union all
          select UnitId, GoodsPropertyId, KindPackageId, zc_DateStart() as PartionDate, PartionStr_MB, StartCount,StartSummIn,EndCount,EndSummIn
          from _tmpList_Remains_byPartionStr_two
         ) as _tmpList_Remains_byKindPackage_two

         left outer join  _tmpList_Bill as _tmp on _tmp.UnitId = _tmpList_Remains_byKindPackage_two.UnitId

         left outer join dba.Bill on Bill.Id = _tmp.BillId
         left outer join dba.GoodsProperty on GoodsProperty.Id = _tmpList_Remains_byKindPackage_two.GoodsPropertyId
         left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId
         left outer join dba.KindPackage on KindPackage.Id = _tmpList_Remains_byKindPackage_two.KindPackageId
                                        -- and Goods.ParentId not in(686,1670,2387,2849,5874) --  “‡‡ + —€– + ’À≈¡ + —-œ≈–≈–¿¡Œ“ ¿ + “”ÿ≈Õ ¿
                                        and GoodsProperty.InfoMoneyCode in(20901,30101) -- »Ì‡  + √ÓÚÓ‚‡ˇ ÔÓ‰ÛÍˆËˇ
         left outer join _tmpList_Partion_find as GoodsProperty_find on GoodsProperty_find.GoodsPropertyId = _tmpList_Remains_byKindPackage_two.GoodsPropertyId
                                                                    and GoodsProperty_find.UnitId = _tmpList_Remains_byKindPackage_two.UnitId

         left outer join dba.BillItems as BI_find on BI_find.Id = GoodsProperty_find.BillItemsId
         -- left outer join dba.Bill as Bill_find on Bill_find.Id = BI_find.BillId

         left outer join dba.Unit on Unit.Id = Bill.FromId
         left outer join dba._pgCar on _pgCar.Id = Unit.CarId_pg

    where MovementId <> 0 
      -- and GoodsProperty.InfoMoneyCode <> 0
    group by Bill.Id_Postgres
           , Bill.BillNumber
           , Bill.BillDate
           , _tmpList_Remains_byKindPackage_two.UnitId
           , GoodsProperty.Id
           , GoodsProperty.Id_Postgres
           , _tmpList_Remains_byKindPackage_two.PartionDate
           , _tmpList_Remains_byKindPackage_two.PartionStr_MB
           , KindPackage.Id_Postgres
           , GoodsProperty.InfoMoneyCode
           , _pgCar.CarId_pg
           , BI_find.SummIn
           , BI_find.OperCount
    order by 4, 3, 5
   ;
    print '----------- end Finish';

end
go
//
-- select gpMovementItem_Inventory_SetErased (inMovementItemId := MovementItem.Id, inSession := '5') from MovementItem where MovementId = 408571;
//
-- call dba._pgSelect_Bill_Inventory_Item (zc_rvNo(), '2014-05-31', '2014-05-31')
