alter FUNCTION DBA.fInsert_pgPartner (in @ClientID integer,in @OKPO TVarCharLongLong,in @adr TVarCharLongLong, in @CodeIM TVarCharLongLong)
returns smallint
begin atomic
    declare @Main integer;

print '@OKPO';
print @OKPO;
print zf_isOKPO_Virtual_PG(@OKPO);


    if trim (@OKPO) = '' then raiserror 21000 'trim (@OKPO)'; end if;
    if zf_isOKPO_Virtual_PG(@OKPO) = zc_rvYes() then raiserror 21000 'zf_isOKPO_Virtual_PG'; end if;


    select max (Main) into @Main from dba._pgPartner where trim (okpo) = trim (@OKPO) and trim (AdrUnit) = trim (@adr) and @Main <> '';

    if isnull(@Main, 0) = 0 then
       select max (Main) into @Main from dba._pgPartner where trim (okpo) = trim (@OKPO) and Main <> '';
    end if;

    set @Main = isnull(@Main, 0) + 1;

    insert into dba._pgPartner (Main
                        , Name
                        , NameAll
                        , OKPO
                        , Adr
                        , UnitId
                        , UnitName
                        , AdrUnit
                        , CodeIM
                        , MoneyKindID

                        , NPP
                        , Inn
                        , NSvid
                        , PHone
                        , FioB
                        , Nalog5
                        , NameIM
                        , ContractName
                        , ContractNumber
                        , Date0
                        , Date1
                        , Date2
                        , ContractVid
                        , NumberSheet

                        )
    select @main, Unit_inf.UnitName, Unit_inf.UnitName, OKPO, AddressFirm, Unit.id, Unit.UnitName,  @adr, @CodeIM, zc_mkNal(), '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    from dba.Unit
         left outer join dba.ClientInformation as Information on Information.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
         left outer join dba.Unit as Unit_inf on Unit_inf.ID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
    where Unit.Id = @ClientID;


    return(0);
end



update dba.ClientInformation
set ClientInformation.OKPO = tmp . okpoNew
from (

select isnull (Information1.ClientId, isnull (Information2.ClientId, 0)) AS ClientId,  isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO, a.okpo as okpoNew
, Unit.*
from (
select '2725117065' as okpo, '7568' as id
union select '2870311941' as okpo, '8691' as id
union select '2874614678' as okpo, '7601' as id
union select '2874614678' as okpo, '7100' as id
union select '2614918397' as okpo, '6856' as id
union select '2614918397' as okpo, '1571' as id
union select '34195448' as okpo, '7604' as id
union select '34195448' as okpo, '7606' as id
union select '34195448' as okpo, '7352' as id
union select '34195448' as okpo, '7605' as id
union select '2263807283' as okpo, '7563' as id
union select '2106702913' as okpo, '3499' as id
union select '2184300546' as okpo, '6760' as id
union select '2284009822' as okpo, '7688' as id
union select '2034607292' as okpo, '1665' as id
union select '3078417696' as okpo, '7860' as id
union select '3078417696' as okpo, '8883' as id
union select '' as okpo, '8509' as id
union select '3124213294' as okpo, '8069' as id
union select '' as okpo, '7358' as id
union select '2152819598' as okpo, '2798' as id
union select '2292700434' as okpo, '718' as id
union select '' as okpo, '4908' as id
union select '' as okpo, '4634' as id
union select '3173518575' as okpo, '7567' as id
union select '1953600900' as okpo, '8505' as id
union select '2226200434' as okpo, '8747' as id
union select '' as okpo, '3594' as id
union select '2646900669' as okpo, '9475' as id
union select '1747309381' as okpo, '7037' as id
union select '2280900468' as okpo, '1925' as id
union select '1840518125' as okpo, '7006' as id
union select '2647712066' as okpo, '' as id
union select '1626706811' as okpo, '7496' as id
union select '1641302607' as okpo, '2946' as id
union select '1920313627' as okpo, '6697' as id
union select '1930000607' as okpo, '6855' as id
union select '19313262' as okpo, '9049' as id
union select '1985117063' as okpo, '7366' as id
union select '2018400197' as okpo, '7575' as id
union select '2030813893' as okpo, '2691' as id
union select '2032902279' as okpo, '7365' as id
union select '2043321162' as okpo, '7851' as id
union select '2055600711' as okpo, '6854' as id
union select '2090908246' as okpo, '4924' as id
union select '2110814046' as okpo, '8398' as id
union select '2129600246' as okpo, '' as id
union select '2123309845' as okpo, '5305' as id
union select '2123309845' as okpo, '5305' as id
union select '2123309845' as okpo, '5310' as id
union select '2123309845' as okpo, '5309' as id
union select '2123309845' as okpo, '5307' as id
union select '2129600246' as okpo, '7077' as id
union select '2136016925' as okpo, '6732' as id
union select '2143000231' as okpo, '6757' as id
union select '2153503262' as okpo, '6762' as id
union select '2156114858' as okpo, '9170' as id
union select '2181200238' as okpo, '9055' as id
union select '2195400404' as okpo, '160' as id
union select '2216721968' as okpo, '9078' as id
union select '2216721968' as okpo, '9078' as id
union select '2221601408' as okpo, '8554' as id
union select '2238507992' as okpo, '7526' as id
union select '2258915161' as okpo, '6691' as id
union select '2259700436' as okpo, '6686' as id
union select '227561823' as okpo, '8529' as id
union select '2284802641' as okpo, '8346' as id
union select '2288406418' as okpo, '4916' as id
union select '2298400426' as okpo, '6667' as id
union select '2321616168' as okpo, '8510' as id
union select '2344212673' as okpo, '6863' as id
union select '2352914240' as okpo, '7018' as id
union select '2354321686' as okpo, '6701' as id
union select '2379104245' as okpo, '9349' as id
union select '2387700205' as okpo, '1637' as id
union select '2392324682' as okpo, '9093' as id
union select '2392324682' as okpo, '9094' as id
union select '3288617787' as okpo, '8528' as id
union select '2562500308' as okpo, '8531' as id
union select '2641115343' as okpo, '8530' as id
union select '2275618623' as okpo, '' as id
union select '2586501870' as okpo, '8532' as id
union select '2221601408' as okpo, '' as id
union select '2885800270' as okpo, '9165' as id
union select '2392513434' as okpo, '6661' as id
union select '2393600146' as okpo, '6862' as id
union select '2409900371' as okpo, '7090' as id
union select '2410500422' as okpo, '4912' as id
union select '2439112709' as okpo, '5338' as id
union select '2443500240' as okpo, '6898' as id
union select '2453320720' as okpo, '9088' as id
union select '2456113040' as okpo, '3593' as id
union select '2473911874' as okpo, '7689' as id
union select '2492317859' as okpo, '7599' as id
union select '2516608761' as okpo, '4917' as id
union select '25521415' as okpo, '6741' as id
union select '2561720875' as okpo, '7779' as id
union select '2571712427' as okpo, '7995' as id
union select '2571712427' as okpo, '8024' as id
union select '2571712427' as okpo, '7997' as id
union select '2571712427' as okpo, '7996' as id
union select '2571712427' as okpo, '7870' as id
union select '2574500375' as okpo, '7327' as id
union select '2593911790' as okpo, '6749' as id
union select '26003400151' as okpo, '' as id
union select '26003400151' as okpo, '8574' as id
union select '26003400151' as okpo, '' as id
union select '26003400151' as okpo, '8574' as id
union select '26005000622' as okpo, '6671' as id
union select '2606613162' as okpo, '6684' as id
union select '2606613162' as okpo, '6679' as id
union select '2608614508' as okpo, '9092' as id
union select '2608614508' as okpo, '9091' as id
union select '2614000589' as okpo, '7924' as id
union select '2634317301' as okpo, '8057' as id
union select '2635622597' as okpo, '9410' as id
union select '2635622597' as okpo, '9409' as id
union select '2635622597' as okpo, '9080' as id
union select '2635622597' as okpo, '9081' as id
union select '2677516544' as okpo, '9082' as id
union select '2639300450' as okpo, '2863' as id
union select '2640219959' as okpo, '8066' as id
union select '2656718356' as okpo, '7038' as id
union select '2656718356' as okpo, '7039' as id
union select '2665815987' as okpo, '9101' as id
union select '2665902082' as okpo, '6682' as id
union select '2671715508' as okpo, '2391' as id
union select '2749007956' as okpo, '3544' as id
union select '2754417664' as okpo, '9095' as id
union select '2754417664' as okpo, '9096' as id
union select '2754810045' as okpo, '9075' as id
union select '2784322536' as okpo, '6811' as id
union select '2823103482' as okpo, '8736' as id
union select '2832614823' as okpo, '7855' as id
union select '2851514580' as okpo, '6659' as id
union select '2868604398' as okpo, '6845' as id
union select '2870311941' as okpo, '6698' as id
union select '2883606597' as okpo, '3879' as id
union select '2898304987' as okpo, '9099' as id
union select '2904012959' as okpo, '2034' as id
union select '2904919498' as okpo, '8050' as id
union select '2931312504' as okpo, '9467' as id
union select '2932503754' as okpo, '7555' as id
union select '2938115775' as okpo, '6931' as id
union select '2946721718' as okpo, '7852' as id
union select '2947203966' as okpo, '8338' as id
union select '2992915094' as okpo, '1676' as id
union select '3027905772' as okpo, '9159' as id
union select '3027905772' as okpo, '9158' as id
union select '3032513343' as okpo, '7949' as id
union select '3032513343' as okpo, '7950' as id
union select '3048921621' as okpo, '7042' as id
union select '3049316921' as okpo, '9085' as id
union select '3053807463' as okpo, '7041' as id
union select '3053807463' as okpo, '7040' as id
union select '3093419621' as okpo, '5129' as id
union select '3099309370' as okpo, '7362' as id
union select '3100620589' as okpo, '8297' as id
union select '3112404286' as okpo, '9050' as id
union select '3123203875' as okpo, '7107' as id
union select '3140512747' as okpo, '8320' as id
union select '3151713503' as okpo, '9285' as id
union select '3159909838' as okpo, '6902' as id
union select '3171319277' as okpo, '2754' as id
union select '3182521301' as okpo, '7118' as id
union select '3204909056' as okpo, '2083' as id
union select '3215103677' as okpo, '7766' as id
union select '32685442' as okpo, '6660' as id
union select '3270416890' as okpo, '8540' as id
union select '3369006922' as okpo, '8730' as id
union select '36095364' as okpo, '7053' as id
union select '36095364' as okpo, '' as id
union select '36840304' as okpo, '6813' as id
union select '36840304' as okpo, '6814' as id
union select '37989206' as okpo, '9353' as id
union select '38114074' as okpo, '7048' as id
) as a
left join unit on Unit.Id = a.Id
left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
           and Information1.OKPO <> ''
left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id

where trim (a.okpo) <> ''  and trim (a.id) <> ''
and okpoNew <> okpo
-- and ClientId <>0
) as tmp
where tmp . ClientId = ClientInformation.ClientId






update dba.ClientInformation
set ClientInformation.OKPO = tmp . okpoNew
from (

select isnull (Information1.ClientId, isnull (Information2.ClientId, 0)) AS ClientId,  isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO, a.okpo as okpoNew
, Unit.*
from (
select '6092' as Code, '35275230' as okpo
union select '8594' as Code, '32516492' as okpo
union select '11738' as Code, '26003400151' as okpo
union select '10642' as Code, '26003400151' as okpo
union select '11737' as Code, '26003400151' as okpo
union select '10643' as Code, '26003400151' as okpo
union select '11653' as Code, '38633934' as okpo
union select '10665' as Code, '2887419380' as okpo
union select '10666' as Code, '2887419380' as okpo
union select '5208' as Code, '2034607292' as okpo
union select '357' as Code, '01*02' as okpo
union select '355' as Code, '01*02' as okpo
union select '5340' as Code, '01-01' as okpo
union select '10470' as Code, '2110814046' as okpo
union select '11706' as Code, '2516605846' as okpo
union select '11656' as Code, '2775417185' as okpo
union select '11658' as Code, '3101918018' as okpo
union select '11657' as Code, '3101918018' as okpo
union select '11660' as Code, '2007304822' as okpo
union select '11809' as Code, '2002206486' as okpo
union select '11437' as Code, '2447713628' as okpo
union select '11896' as Code, '3058015041' as okpo
union select '11487' as Code, '1989120981' as okpo
union select '11436' as Code, '2562320944' as okpo
union select '11849' as Code, '3348114353' as okpo
union select '11690' as Code, '2693119629' as okpo
union select '11533' as Code, '2283406469' as okpo
union select '11420' as Code, '1532303538' as okpo
union select '11423' as Code, '2224309795' as okpo
union select '11861' as Code, '3086714595' as okpo
union select '11414' as Code, '2488317307' as okpo
union select '11634' as Code, '2124605772' as okpo
union select '11838' as Code, '1994621481' as okpo
union select '11839' as Code, '1994621481' as okpo
union select '11422' as Code, '3239509310' as okpo
union select '11413' as Code, '2460007044' as okpo
union select '11504' as Code, '2602516473' as okpo
union select '11620' as Code, '2428400179' as okpo
union select '11897' as Code, '2995420786' as okpo
union select '11415' as Code, '3172916427' as okpo
union select '5198' as Code, '2054526966' as okpo
union select '11412' as Code, '2475115715' as okpo
union select '11628' as Code, '2539809876' as okpo
union select '11898' as Code, '2141020014' as okpo
union select '11630' as Code, '2185503081' as okpo
union select '7149' as Code, '2731209943' as okpo
union select '8410' as Code, '2731209943' as okpo
union select '7993' as Code, '2731209943' as okpo
union select '11305' as Code, '2731209943' as okpo
union select '10669' as Code, '2731209943' as okpo
union select '10342' as Code, '2731209943' as okpo
union select '9460' as Code, '2731209943' as okpo
union select '9552' as Code, '2731209943' as okpo
union select '10343' as Code, '2731209943' as okpo
union select '8668' as Code, '2731209943' as okpo
union select '10370' as Code, '2646900669' as okpo
union select '9553' as Code, '2646900669' as okpo
union select '10667' as Code, '2646900669' as okpo
union select '11613' as Code, '2646900669' as okpo
union select '10793' as Code, '2646900669' as okpo
union select '10792' as Code, '2646900669' as okpo
union select '10791' as Code, '2646900669' as okpo
union select '10752' as Code, '2646900669' as okpo
union select '8629' as Code, '2646900669' as okpo
union select '8116' as Code, '2731209943' as okpo
union select '719' as Code, '2827503871' as okpo
union select '718' as Code, '01*02' as okpo
union select '8466' as Code, '2539105277' as okpo
union select '6343' as Code, '01-01' as okpo
union select '799' as Code, '2123309845' as okpo
union select '6473' as Code, '01-01' as okpo
union select '8806' as Code, '25521415' as okpo
union select '8806' as Code, '25521415' as okpo
union select '7501' as Code, '20280734' as okpo
union select '8856' as Code, '32685442' as okpo
union select '8823' as Code, '2143000231' as okpo
union select '11187' as Code, '01*02' as okpo
union select '5229' as Code, '2992915094' as okpo
union select '8506' as Code, '01-01' as okpo
union select '9128' as Code, '2129600246' as okpo
union select '9472' as Code, '2684901843' as okpo
union select '7895' as Code, '01-01' as okpo
union select '9072' as Code, '2392513434' as okpo
union select '8723' as Code, '2392513434' as okpo
union select '828' as Code, '01-01' as okpo
union select '9443' as Code, '1626706811' as okpo
union select '8878' as Code, '1960312195' as okpo
union select '906' as Code, '01-01' as okpo
union select '8749' as Code, '1976300625' as okpo
union select '8501' as Code, '3093419621' as okpo
union select '8096' as Code, '2410500422' as okpo
union select '9543' as Code, '2492317859' as okpo
union select '9453' as Code, '2492317859' as okpo
union select '7633' as Code, '2123455672' as okpo
union select '9545' as Code, '2874614678' as okpo
union select '9149' as Code, '2874614678' as okpo
union select '11240' as Code, '2648411427' as okpo
union select '8763' as Code, '2354321686' as okpo
union select '9103' as Code, '2600702000' as okpo
union select '9063' as Code, '2192909445' as okpo
union select '5405' as Code, '3115445617' as okpo
union select '988' as Code, '2889411155' as okpo
union select '11856' as Code, '2155420644' as okpo
union select '9510' as Code, '2263807283' as okpo
union select '11847' as Code, '2705116005' as okpo
union select '8575' as Code, '2946508958' as okpo
union select '715' as Code, '2615912408' as okpo
union select '9314' as Code, '1985117063' as okpo
union select '9314' as Code, '1985117063' as okpo
union select '11846' as Code, '1778800702' as okpo
union select '8991' as Code, '2938115775' as okpo
union select '9548' as Code, '34195448' as okpo
union select '9550' as Code, '34195448' as okpo
union select '9549' as Code, '34195448' as okpo
union select '9301' as Code, '34195448' as okpo
union select '9166' as Code, '3182521301' as okpo
union select '9434' as Code, '3012406179' as okpo
union select '9300' as Code, '2541020596' as okpo
union select '11876' as Code, '2454678934' as okpo
union select '7701' as Code, '01*02' as okpo
union select '9100' as Code, '38114074' as okpo
union select '5450' as Code, '01-01' as okpo
union select '8928' as Code, '2393600146' as okpo
union select '8909' as Code, '2868604398' as okpo
union select '8744' as Code, '2665902082' as okpo
union select '9407' as Code, '3013611508' as okpo
union select '9094' as Code, '3048921621' as okpo
union select '6843' as Code, '2456113040' as okpo
union select '9073' as Code, '2352914240' as okpo
union select '9062' as Code, '2442217432' as okpo
union select '845' as Code, '3033407450' as okpo
union select '9312' as Code, '2032902279' as okpo
union select '10578' as Code, '01-01' as okpo
union select '8024' as Code, '2431222178' as okpo
union select '8101' as Code, '2516608761' as okpo
union select '8746' as Code, '2606613162' as okpo
union select '8741' as Code, '2606613162' as okpo
union select '8759' as Code, '1920313627' as okpo
union select '8967' as Code, '3159909838' as okpo
union select '9305' as Code, '01-01' as okpo
union select '6422' as Code, '33184262' as okpo
union select '8913' as Code, '3144509702' as okpo
union select '10376' as Code, '01*02' as okpo
union select '9450' as Code, '01*02' as okpo
union select '5168' as Code, '1988817912' as okpo
union select '5168' as Code, '1988817912' as okpo
union select '9043' as Code, '3013307630' as okpo
union select '8795' as Code, '2136016925' as okpo
union select '9521' as Code, '2018400197' as okpo
union select '8747' as Code, '2636517591' as okpo
union select '7443' as Code, '01*02' as okpo
union select '11640' as Code, '2172219208' as okpo
union select '995' as Code, '2172219208' as okpo
union select '8815' as Code, '2593911790' as okpo
union select '9474' as Code, '2238507992' as okpo
union select '7765' as Code, '3152205512' as okpo
union select '9513' as Code, '3173518575' as okpo
union select '7952' as Code, '30982361' as okpo
union select '7954' as Code, '30982361' as okpo
union select '10910' as Code, '30982361' as okpo
union select '10911' as Code, '30982361' as okpo
union select '10915' as Code, '30982361' as okpo
union select '10916' as Code, '30982361' as okpo
union select '10914' as Code, '30982361' as okpo
union select '10917' as Code, '30982361' as okpo
union select '9277' as Code, '2574500375' as okpo
union select '9156' as Code, '3123203875' as okpo
union select '8969' as Code, '1816218463' as okpo
union select '10811' as Code, '2226200434' as okpo
union select '9061' as Code, '1840518125' as okpo
union select '9505' as Code, '2894307472' as okpo
union select '7577' as Code, '01-01' as okpo
union select '8509' as Code, '01-01' as okpo
union select '9141' as Code, '2409900371' as okpo
union select '8929' as Code, '2344212673' as okpo
union select '9059' as Code, '01*02' as okpo
union select '8100' as Code, '2288406418' as okpo
union select '9445' as Code, '2388118510' as okpo
union select '9648' as Code, '24437204' as okpo
union select '9894' as Code, '01*02' as okpo
union select '9633' as Code, '2473911874' as okpo
union select '9721' as Code, '2561720875' as okpo
union select '6585' as Code, '01*02' as okpo
union select '9792' as Code, '2946721718' as okpo
union select '9632' as Code, '2284009822' as okpo
union select '9791' as Code, '2043321162' as okpo
union select '11021' as Code, '3078417696' as okpo
union select '9795' as Code, '2832614823' as okpo
union select '9711' as Code, '2699105012' as okpo
union select '9631' as Code, '1793428866' as okpo
union select '9797' as Code, '2885525644' as okpo
union select '9796' as Code, '2885525644' as okpo
union select '9710' as Code, '3215103677' as okpo
union select '9865' as Code, '2614000589' as okpo
union select '6137' as Code, '35442481' as okpo
union select '889' as Code, '01*02' as okpo
union select '9089' as Code, '1747309381' as okpo
union select '9090' as Code, '2656718356' as okpo
union select '9091' as Code, '2656718356' as okpo
union select '8930' as Code, '2423814847' as okpo
union select '9101' as Code, '3104614606' as okpo
union select '469' as Code, '34829467' as okpo
union select '908' as Code, '3049509656' as okpo
union select '11646' as Code, '1864916642' as okpo
union select '11648' as Code, '1864916642' as okpo
union select '11649' as Code, '1864916642' as okpo
union select '11647' as Code, '1864916642' as okpo
union select '11655' as Code, '2725724153' as okpo
union select '9801' as Code, '2884008562' as okpo
union select '11732' as Code, '3311119434' as okpo
union select '10640' as Code, '2534515505' as okpo
union select '10662' as Code, '2534515505' as okpo
union select '6485' as Code, '32294926' as okpo
union select '7891' as Code, '33184262' as okpo
union select '6434' as Code, '33184262' as okpo
union select '10002' as Code, '2640219959' as okpo
union select '9932' as Code, '2571712427' as okpo
union select '9960' as Code, '2571712427' as okpo
union select '9934' as Code, '2571712427' as okpo
union select '9811' as Code, '2571712427' as okpo
union select '7437' as Code, '01-01' as okpo
union select '8837' as Code, '2975015509' as okpo
union select '8837' as Code, '2975015509' as okpo
union select '7939' as Code, '3115519396' as okpo
union select '832' as Code, '01-01' as okpo
union select '6325' as Code, '01-01' as okpo
union select '9379' as Code, '01-01' as okpo
union select '8487' as Code, '2231218023' as okpo
union select '6801' as Code, '3193312096  ' as okpo
union select '7269' as Code, '01-01' as okpo
union select '8866' as Code, '01-01' as okpo
union select '5480' as Code, '01-01' as okpo
union select '545' as Code, '2315108146' as okpo
union select '6463' as Code, '2315108146' as okpo
union select '1899' as Code, '01-01' as okpo
union select '7188' as Code, '01-01' as okpo
union select '6098' as Code, '01-01' as okpo
union select '6106' as Code, '01-01' as okpo
union select '0' as Code, '01-01' as okpo
union select '6105' as Code, '01-01' as okpo
union select '6096' as Code, '01-01' as okpo
union select '6103' as Code, '01-01' as okpo
union select '6135' as Code, '01-01' as okpo
union select '6263' as Code, '01-01' as okpo
union select '6193' as Code, '01-01' as okpo
union select '6487' as Code, '01-01' as okpo
union select '7435' as Code, '01-01' as okpo
union select '9313' as Code, '01-01' as okpo
union select '781' as Code, '01*02' as okpo
union select '11792' as Code, '2404615224' as okpo
union select '11789' as Code, '1978312151' as okpo
union select '11790' as Code, '2584609775' as okpo
union select '6043' as Code, '32104254' as okpo
union select '5296' as Code, '32104254' as okpo
union select '10660' as Code, '2873619283' as okpo
union select '10659' as Code, '2138208301' as okpo
union select '10641' as Code, '2052212004' as okpo
union select '10383' as Code, '2513315706' as okpo
union select '11369' as Code, '2513315706' as okpo
union select '11811' as Code, '3233615933' as okpo
union select '11810' as Code, '3233615933' as okpo
union select '704' as Code, '01-01' as okpo
union select '11756' as Code, '2693000301' as okpo
union select '11764' as Code, '2693000301' as okpo
union select '11765' as Code, '2693000301' as okpo
union select '11767' as Code, '2693000301' as okpo
union select '11757' as Code, '2693000301' as okpo
union select '11761' as Code, '2693000301' as okpo
union select '11762' as Code, '2693000301' as okpo
union select '11298' as Code, '2885800270' as okpo
union select '10655' as Code, '38561231' as okpo
union select '11766' as Code, '2947805855' as okpo
union select '11758' as Code, '2947805855' as okpo
union select '11759' as Code, '2947805855' as okpo
union select '11760' as Code, '2947805855' as okpo
union select '11763' as Code, '2947805855' as okpo
union select '11740' as Code, '2947805855' as okpo
union select '0' as Code, '01-01' as okpo
union select '7300' as Code, '01-01' as okpo
union select '6370' as Code, '2883413833' as okpo
union select '5070' as Code, '32049199' as okpo
union select '11742' as Code, '2899521033' as okpo
union select '744' as Code, '30269201' as okpo
union select '10367' as Code, '3100620589' as okpo
union select '6230' as Code, '1641302607' as okpo
union select '8975' as Code, '30982361' as okpo
union select '9084' as Code, '30982361' as okpo
union select '8989' as Code, '30982361' as okpo
union select '9307' as Code, '30982361' as okpo
union select '9451' as Code, '30982361' as okpo
union select '9938' as Code, '30982361' as okpo
union select '9032' as Code, '30982361' as okpo
union select '9412' as Code, '30982361' as okpo
union select '9403' as Code, '33184262' as okpo
union select '9890' as Code, '3032513343' as okpo
union select '9891' as Code, '3032513343' as okpo
union select '8942' as Code, '30982361' as okpo
union select '9203' as Code, '30982361' as okpo
union select '9226' as Code, '30982361' as okpo
union select '8937' as Code, '30982361' as okpo
union select '11704' as Code, '30982361' as okpo
union select '5402' as Code, '30982361' as okpo
union select '8336' as Code, '30982361' as okpo
union select '11769' as Code, '2465120947' as okpo
union select '8554' as Code, '2678706743' as okpo
union select '892' as Code, '2678706743' as okpo
union select '1793' as Code, '2583815118' as okpo
union select '1796' as Code, '2209600283' as okpo
union select '7056' as Code, '2209600283' as okpo
union select '7442' as Code, '2209600283' as okpo
union select '6020' as Code, '2209600283' as okpo
union select '1794' as Code, '2583815118' as okpo
union select '1792' as Code, '2583815118' as okpo
union select '9655' as Code, '2583815118' as okpo
union select '1795' as Code, '2814013147' as okpo
union select '5408' as Code, '2814013147' as okpo
union select '6219' as Code, '2596109617' as okpo
union select '11735' as Code, '2770802756' as okpo
union select '11659' as Code, '2770802756' as okpo
union select '9993' as Code, '2634317301' as okpo
union select '730' as Code, '01-01' as okpo
union select '6763' as Code, '2106702913' as okpo
union select '1000' as Code, '01*02' as okpo
union select '10026' as Code, '24437204' as okpo
union select '11782' as Code, '01*02' as okpo
union select '706' as Code, '01*02' as okpo
union select '6969' as Code, '2280900468' as okpo
union select '9886' as Code, '01*02' as okpo
union select '9093' as Code, '3053807463' as okpo
union select '9092' as Code, '3053807463' as okpo
union select '770' as Code, '2195400404' as okpo
union select '709' as Code, '2292700434' as okpo
union select '10574' as Code, '1953600900' as okpo
union select '11374' as Code, '01*02' as okpo
union select '812' as Code, '01*02' as okpo
union select '9724' as Code, '01-01' as okpo
union select '785' as Code, '01-01' as okpo
union select '7646' as Code, '01-01' as okpo
union select '11370' as Code, '27346106113' as okpo
union select '10382' as Code, '27346106113' as okpo
union select '909' as Code, '01-01' as okpo
union select '6242' as Code, '37910513' as okpo
union select '5397' as Code, '37910513' as okpo
union select '6238' as Code, '37910513' as okpo
union select '11272' as Code, '2402215533' as okpo
union select '9893' as Code, '38752477' as okpo
union select '11709' as Code, '2103105101' as okpo
union select '8947' as Code, '33184262' as okpo
union select '9987' as Code, '33184262' as okpo
union select '11292' as Code, '3027905772' as okpo
union select '11291' as Code, '3027905772' as okpo
union select '8880' as Code, '36840304' as okpo
union select '8879' as Code, '36840304' as okpo
union select '8963' as Code, '2443500240' as okpo
union select '11484' as Code, '37989206' as okpo
union select '10580' as Code, '2321616168' as okpo
union select '5438' as Code, '2671715508' as okpo
union select '5222' as Code, '24995973' as okpo
union select '5184' as Code, '2387700205' as okpo
union select '8756' as Code, '2258915161' as okpo
union select '11743' as Code, '3036417998' as okpo
union select '8920' as Code, '2055600711' as okpo
union select '10904' as Code, '3046029935' as okpo
union select '10384' as Code, '3140512747' as okpo
union select '5201' as Code, '1986400478' as okpo
union select '8751' as Code, '2110814046' as okpo
union select '9514' as Code, '2725117065' as okpo
union select '8721' as Code, '2851514580' as okpo
union select '5237' as Code, '2453700629' as okpo
union select '5237' as Code, '2453700629' as okpo
union select '6095' as Code, '30619729' as okpo
union select '8921' as Code, '1930000607' as okpo
union select '8760' as Code, '2870311941' as okpo
union select '10407' as Code, '2284802641' as okpo
union select '10602' as Code, '2586501870' as okpo
union select '10599' as Code, '227561823' as okpo
union select '5482' as Code, '2030813893' as okpo
union select '11185' as Code, '3112404286' as okpo
union select '11605' as Code, '2931312504' as okpo
union select '8107' as Code, '22474002564' as okpo
union select '9995' as Code, '19100299' as okpo
union select '7491' as Code, '1689200501' as okpo
union select '8108' as Code, '2090908246' as okpo
union select '8922' as Code, '2614918397' as okpo
union select '5362' as Code, '2647712066' as okpo
union select '11190' as Code, '2181200238' as okpo
union select '11416' as Code, '3151713503' as okpo
union select '8733' as Code, '26005000622' as okpo
union select '8826' as Code, '2184300546' as okpo
union select '7119' as Code, '2883606597' as okpo
union select '8748' as Code, '2259700436' as okpo
union select '5334' as Code, '3204909056' as okpo
union select '8833' as Code, '2439000782' as okpo
union select '11673' as Code, '3352608881' as okpo
union select '9800' as Code, '3078417696' as okpo
union select '9986' as Code, '2904919498' as okpo
union select '8719' as Code, '1794123424' as okpo
union select '5294' as Code, '2904012959' as okpo
union select '10103' as Code, '2325425780' as okpo
union select '10381' as Code, '2737109978' as okpo
union select '6799' as Code, '2749007956' as okpo
union select '9309' as Code, '3099309370' as okpo
union select '10399' as Code, '2947203966' as okpo
union select '8828' as Code, '2153503262' as okpo
union select '10005' as Code, '3124213294' as okpo
union select '8877' as Code, '2784322536' as okpo
union select '11675' as Code, '2459805428' as okpo
union select '11674' as Code, '2459805428' as okpo
union select '11303' as Code, '2156114858' as okpo
union select '6086' as Code, '2152819598' as okpo
union select '8705' as Code, '2439112709' as okpo
union select '10800' as Code, '2823103482' as okpo
union select '11480' as Code, '2379104245' as okpo
union select '10601' as Code, '2562500308' as okpo
union select '10598' as Code, '3288617787' as okpo
union select '6844' as Code, '3164510206' as okpo
union select '6844' as Code, '3164510206' as okpo
union select '8729' as Code, '2298400426' as okpo
union select '6045' as Code, '3171319277' as okpo
union select '10795' as Code, '3369006922' as okpo
union select '10623' as Code, '2221601408' as okpo
union select '11184' as Code, '19313262' as okpo
union select '6409' as Code, '01*02' as okpo
union select '8974' as Code, '30982361' as okpo
union select '5085' as Code, '30982361' as okpo
union select '6161' as Code, '01-01' as okpo
union select '5106' as Code, '30344629' as okpo
union select '10609' as Code, '3270416890' as okpo
union select '11753' as Code, '3079205161' as okpo
union select '10339' as Code, '38685495' as okpo
union select '11230' as Code, '2754417664' as okpo
union select '11231' as Code, '2754417664' as okpo
union select '11228' as Code, '2392324682' as okpo
union select '11229' as Code, '2392324682' as okpo
union select '11223' as Code, '2453320720' as okpo
union select '11220' as Code, '3049316921' as okpo
union select '11227' as Code, '2608614508' as okpo
union select '11226' as Code, '2608614508' as okpo
union select '11772' as Code, '2927317466' as okpo
union select '11210' as Code, '2754810045' as okpo
union select '11235' as Code, '2665815987' as okpo
union select '11236' as Code, '2665815987' as okpo
union select '11213' as Code, '2216721968' as okpo
union select '11214' as Code, '2216721968' as okpo
union select '11215' as Code, '2635622597' as okpo
union select '11216' as Code, '2635622597' as okpo
union select '11548' as Code, '2635622597' as okpo
union select '11547' as Code, '2635622597' as okpo
union select '11217' as Code, '2677516544' as okpo
union select '11234' as Code, '2898304987' as okpo
union select '9976' as Code, '2500100543' as okpo
union select '9897' as Code, '32294926' as okpo
union select '9898' as Code, '32294926' as okpo
union select '9901' as Code, '32294926' as okpo
union select '8382' as Code, '32294926' as okpo
union select '9118' as Code, '32294926' as okpo
union select '5394' as Code, '36387233' as okpo
union select '11433' as Code, '36387249' as okpo
union select '8707' as Code, '01-01' as okpo
union select '7971' as Code, '2113171691' as okpo
union select '8711' as Code, '01-01' as okpo
union select '9138' as Code, '2161201181' as okpo
union select '9083' as Code, '30237468' as okpo
union select '9217' as Code, '1512024844' as okpo
union select '8916' as Code, '2577013877' as okpo
union select '7424' as Code, '31929492' as okpo
union select '905' as Code, '2937806191' as okpo
union select '8632' as Code, '2824257516' as okpo
union select '8771' as Code, '2533600065' as okpo
union select '7416' as Code, '01-01' as okpo
union select '0' as Code, '01-01' as okpo
union select '7128' as Code, '01-01' as okpo
union select '7707' as Code, '31929492' as okpo
union select '9941' as Code, '2243923658' as okpo
union select '7766' as Code, '2068102869' as okpo
union select '11714' as Code, '2068102869' as okpo
union select '5999' as Code, '01-01' as okpo
union select '11712' as Code, '3019514493' as okpo
union select '7240' as Code, '2639300450' as okpo
union select '7240' as Code, '2639300450' as okpo
union select '11786' as Code, '2639300450' as okpo
union select '9968' as Code, '38183389' as okpo
union select '11599' as Code, '38183389' as okpo
union select '10573' as Code, '2608200664' as okpo
) as a
left join unit on Unit.UnitCode = a.Code
              and a.Code <> 0
left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
           and Information1.OKPO <> ''
left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id

where trim (a.okpo) <> ''  and trim (a.Code) <> '0'
and okpoNew <> okpo
-- and ClientId <>0
) as tmp
where tmp . ClientId = ClientInformation.ClientId