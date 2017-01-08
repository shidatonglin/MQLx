//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Candle\CandleManagerBase.mqh"
#include "..\Signal\SignalsBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Time\TimesBase.mqh"
#include "..\Ordermanager\OrderManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisorBase : public CObject
  {
protected:
   //--- trade parameters
   bool              m_active;
   string            m_name;
   //--- signal parameters
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   string            m_symbol_name;
   int               m_period;
   bool              m_position_reverse;
   //--- signal objects
   CSignals         *m_signals;
   //--- trade objects   
   CAccountInfo      m_account;
   CSymbolManager    m_symbol_man;
   COrderManager     m_order_man;
   //--- trading time objects
   CTimes           *m_times;
   //--- candle
   CCandleManager    m_candle_man;
   //--- events
   CEventAggregator *m_event_man;
   //--- container
   CObject          *m_container;
public:
                     CExpertAdvisorBase(void);
                    ~CExpertAdvisorBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_EXPERT;}
   //--- initialization
   bool              AddEventAggregator(CEventAggregator*);
   bool              AddMoneys(CMoneys*);
   bool              AddSignal(CSignals*);
   bool              AddStops(CStops*);
   bool              AddSymbol(const string);
   bool              AddTimes(CTimes*);
   virtual bool      Init(const string,const int,const int,const bool,const bool,const bool);
   virtual bool      InitAccount(void);
   virtual bool      InitCandleManager(void);
   virtual bool      InitEventAggregator(void);
   virtual bool      InitComponents(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitOrderManager(void);
   virtual bool      Validate(void) const;
   //--- container
   void              SetContainer(CObject*);
   CObject          *GetContainer(void);
   //--- activation and deactivation
   bool              Active(void) const;
   void              Active(const bool);
   //--- setters and getters       
   string            Name(void) const;
   void              Name(const string);
   string            SymbolName(void) const;
   void              SymbolName(const string);
   //--- object pointers
   CAccountInfo     *AccountInfo(void);
   CStop            *MainStop(void);
   CMoneys          *Moneys(void);
   COrders          *Orders(void);
   COrders          *OrdersHistory(void);
   CArrayInt        *OtherMagic(void);
   CStops           *Stops(void);
   CSignals         *Signals(void);
   CTimes           *Times(void);
   //--- order manager
   bool              AddOtherMagic(const int);
   void              AddOtherMagicString(const string&[]);
   void              AsyncMode(const string,const bool);
   string            Comment(void) const;
   void              Comment(const string);
   bool              EnableTrade(void) const;
   void              EnableTrade(bool);
   bool              EnableLong(void) const;
   void              EnableLong(bool);
   bool              EnableShort(void) const;
   void              EnableShort(bool);
   int               Expiration(void) const;
   void              Expiration(const int);
   double            LotSize(void) const;
   void              LotSize(const double);
   int               MaxOrdersHistory(void) const;
   void              MaxOrdersHistory(const int);
   int               Magic(void) const;
   void              Magic(const int);
   uint              MaxTrades(void) const;
   void              MaxTrades(const int);
   int               MaxOrders(void) const;
   void              MaxOrders(const int);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               PricePoints(void) const;
   void              PricePoints(const int);
   int               TradesTotal(void) const;
   //--- signal manager   
   int               Period(void) const;
   void              Period(const int);
   bool              EveryTick(void) const;
   void              EveryTick(const bool);
   bool              OneTradePerCandle(void) const;
   void              OneTradePerCandle(const bool);
   bool              PositionReverse(void) const;
   void              PositionReverse(const bool);
   //--- additional candles
   void              AddCandle(const string,const int);
   //--- new bar detection
   void              DetectNewBars(void);
   //-- events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&);
   virtual void      OnTimer(void);
   virtual void      OnTrade(void);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);

protected:
   //--- candle manager   
   virtual bool      IsNewBar(const string,const int);
   //--- order manager
   virtual void      ManageOrders(void);
   virtual void      ManageOrdersHistory(void);
   virtual void      OnTradeTransaction(COrder*) {}
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE);
   //virtual COrder*   TradeOpen(const string,const ENUM_ORDER_TYPE);
   //--- symbol manager
   virtual bool      RefreshRates(void);
   //--- deinitialization
   void              Deinit(const int);
   void              DeinitAccount(void);
   void              DeinitSignals(void);
   void              DeinitSymbol(void);
   void              DeinitTimes(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::CExpertAdvisorBase(void) : m_active(true),
                                               m_every_tick(true),
                                               m_symbol_name(NULL),
                                               m_one_trade_per_candle(true),
                                               m_period(PERIOD_CURRENT),
                                               m_position_reverse(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::~CExpertAdvisorBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CExpertAdvisorBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Name(const string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::Name(void) const
  {
   return m_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::SymbolName(const string name)
  {
   m_symbol_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::SymbolName(void) const
  {
   return m_symbol_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAccountInfo *CExpertAdvisorBase::AccountInfo(void)
  {
   return GetPointer(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneys *CExpertAdvisorBase::Moneys(void)
  {
   return m_order_man.Moneys();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *CExpertAdvisorBase::Orders(void)
  {
   return m_order_man.Orders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *CExpertAdvisorBase::OrdersHistory(void)
  {
   return m_order_man.OrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayInt *CExpertAdvisorBase::OtherMagic(void)
  {
   return m_order_man.OtherMagic();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStops *CExpertAdvisorBase::Stops(void)
  {
   return m_order_man.Stops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignals *CExpertAdvisorBase::Signals(void)
  {
   return GetPointer(m_signals);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimes *CExpertAdvisorBase::Times(void)
  {
   return GetPointer(m_times);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddOtherMagic(const int magic)
  {
   return m_order_man.AddOtherMagic(magic);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AddOtherMagicString(const string &magics[])
  {
   m_order_man.AddOtherMagicString(magics);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AsyncMode(const string symbol,const bool async)
  {
   m_order_man.AsyncMode(symbol,async);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::Comment(void) const
  {
   return m_order_man.Comment();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Comment(const string comment)
  {
   m_order_man.Comment(comment);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableTrade(void) const
  {
   return m_order_man.EnableTrade();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableTrade(bool allowed)
  {
   m_order_man.EnableTrade(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableLong(void) const
  {
   return m_order_man.EnableLong();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableLong(bool allowed)
  {
   m_order_man.EnableLong(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableShort(void) const
  {
   return m_order_man.EnableShort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableShort(bool allowed)
  {
   m_order_man.EnableShort(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Expiration(void) const
  {
   return m_order_man.Expiration();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Expiration(const int expiration)
  {
   m_order_man.Expiration(expiration);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CExpertAdvisorBase::LotSize(void) const
  {
   return m_order_man.LotSize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::LotSize(const double lotsize)
  {
   m_order_man.LotSize(lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::MaxOrdersHistory(void) const
  {
   return m_order_man.MaxOrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxOrdersHistory(const int max)
  {
   m_order_man.MaxOrdersHistory(max);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Magic(void) const
  {
   return m_order_man.Magic();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Magic(const int magic)
  {
   m_order_man.Magic(magic);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CExpertAdvisorBase::MaxTrades(void) const
  {
   return m_order_man.MaxTrades();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxTrades(const int max_trades)
  {
   m_order_man.MaxTrades(max_trades);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::MaxOrders(void) const
  {
   return m_order_man.MaxOrders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxOrders(const int max_orders)
  {
   m_order_man.MaxOrders(max_orders);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::OrdersTotal(void) const
  {
   return m_order_man.OrdersTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::OrdersHistoryTotal(void) const
  {
   return m_order_man.OrdersHistoryTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::PricePoints(void) const
  {
   return m_order_man.PricePoints();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::PricePoints(const int points)
  {
   m_order_man.PricePoints(points);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::TradesTotal(void) const
  {
   return m_order_man.TradesTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Init(string symbol,int period,int magic,bool every_tick=true,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   m_symbol_name=symbol;
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   m_symbol_man.Add(instrument);
   m_symbol_man.SetPrimary(m_symbol_name);
   m_period=(ENUM_TIMEFRAMES)period;
   m_every_tick=every_tick;
   m_order_man.Magic(magic);
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   CCandle *candle=new CCandle();
   candle.Init(instrument,m_period);
   m_candle_man.Add(candle);
   Magic(magic);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitComponents(void)
  {
   if(!InitSignals())
     {
      Print(__FUNCTION__+": error in signal initialization");
      return false;
     }
   if(!InitTimes())
     {
      Print(__FUNCTION__+": error in time initialization");
      return false;
     }
   if(!InitOrderManager())
     {
      Print(__FUNCTION__+": error in order manager initialization");
      return false;
     }
   if(!InitCandleManager())
     {
      Print(__FUNCTION__+": error in candle manager initialization");
      return false;
     }
   if(!InitEventAggregator())
     {
      Print(__FUNCTION__+": error in event aggregator initialization");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitSignals(void)
  {
   if(!CheckPointer(m_signals))
      return true;
   return m_signals.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitTimes(void)
  {
   if(!CheckPointer(m_times))
      return true;
   return m_times.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitOrderManager(void)
  {
   return m_order_man.Init(GetPointer(m_symbol_man),GetPointer(m_account));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitCandleManager(void)
  {
   m_candle_man.SetContainer(GetPointer(this));
   return m_candle_man.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitEventAggregator(void)
  {
   if(CheckPointer(m_event_man))
      return m_event_man.Init();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddMoneys(CMoneys *moneys)
  {
   return m_order_man.AddMoneys(GetPointer(moneys));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddEventAggregator(CEventAggregator *aggregator)
  {
   if(CheckPointer(m_event_man))
      delete m_event_man;
   m_event_man=aggregator;
   return CheckPointer(m_event_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddSignal(CSignals *signals)
  {
   if(CheckPointer(m_signals))
      delete m_signals;
   m_signals=signals;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddStops(CStops *stops)
  {
   return m_order_man.AddStops(GetPointer(stops));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddSymbol(string symbol)
  {
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   return m_symbol_man.Add(instrument);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddTimes(CTimes *times)
  {
   if(CheckPointer(times)==POINTER_DYNAMIC)
     {
      m_times=times;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AddCandle(const string symbol,const int timeframe)
  {
   m_candle_man.Add(symbol,timeframe);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Validate(void) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
     {
      if(!m_signals.Validate())
         return false;
     }
   if(CheckPointer(m_times)==POINTER_DYNAMIC)
     {
      if(!m_times.Validate())
         return false;
     }
   return m_order_man.Validate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Period(const int value)
  {
   m_period=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Period(void) const
  {
   return m_period;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EveryTick(const bool value)
  {
   m_every_tick=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EveryTick(void) const
  {
   return m_every_tick;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::OneTradePerCandle(const bool value)
  {
   m_one_trade_per_candle=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::OneTradePerCandle(void) const
  {
   return m_one_trade_per_candle;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::PositionReverse(const bool value)
  {
   m_position_reverse=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::PositionReverse(void) const
  {
   return m_position_reverse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DetectNewBars(void)
  {
   m_candle_man.Check();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::IsNewBar(const string symbol,const int period)
  {
   return m_candle_man.IsNewCandle(symbol,period);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool CExpertAdvisorBase::TradeOpen(const string symbol,const ENUM_ORDER_TYPE type)
  {
   return m_order_man.TradeOpen(symbol,type);
  }
/*
COrder* CExpertAdvisorBase::TradeOpen(const string symbol,const ENUM_ORDER_TYPE type)
  {
   return m_order_man.TradeOpen(symbol,type);
  }
*/  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::ManageOrders(void)
  {
   m_order_man.ManageOrders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::ManageOrdersHistory(void)
  {
   m_order_man.ManageOrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::OnTick(void)
  {
   if(!Active())
      return false;
   if(!RefreshRates())
      return false;
   DetectNewBars();
   bool checkopenlong=false,
   checkopenshort=false,
   checkcloselong=false,
   checkcloseshort=false;
   if(CheckPointer(m_signals))
     {
      m_signals.Check();
      checkopenlong=m_signals.CheckOpenLong();
      checkopenshort = m_signals.CheckOpenShort();
      checkcloselong = m_signals.CheckCloseLong();
      checkcloseshort= m_signals.CheckCloseShort();
     }
   COrders *orders=m_order_man.Orders();
   for(int i=orders.Total()-1;i>=0;i--)
     {
      COrder *order=orders.At(i);
      if(!CheckPointer(order))
         continue;
      order.OnTick();
      if(order.IsSuspended())
        {
         if(m_order_man.CloseOrder(order,i))
            continue;
        }
      
      if((m_position_reverse && 
         ((checkopenlong && order.OrderType()==ORDER_TYPE_SELL) ||
         (checkopenshort && order.OrderType()==ORDER_TYPE_BUY))) ||
         (checkcloselong && order.OrderType()==ORDER_TYPE_BUY) ||
         (checkcloseshort && order.OrderType()==ORDER_TYPE_SELL))
        {         
         if(m_order_man.CloseOrder(order,i))
            continue;
        }
     }
   m_order_man.OnTick();
   if(CheckPointer(m_signals) && 
      (m_every_tick || IsNewBar(m_symbol_name,m_period)) && 
      (!CheckPointer(m_times) || m_times.Evaluate()))
     {
      if(checkopenlong)
      {
         return TradeOpen(m_symbol_name,ORDER_TYPE_BUY);
      }   
      if(checkopenshort)
      {
         return TradeOpen(m_symbol_name,ORDER_TYPE_SELL); 
      }   
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnTimer(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnTrade(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::RefreshRates()
  {
   return m_symbol_man.RefreshRates();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::Deinit(const int reason=0)
  {
   DeinitSymbol();
   DeinitSignals();
   DeinitTimes();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSignals(void)
  {
   delete m_signals;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSymbol(void)
  {
   m_symbol_man.Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitTimes(void)
  {
   if(CheckPointer(m_times))
      delete m_times;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Save(const int handle)
  {
   return m_order_man.Save(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Load(const int handle)
  {
   return m_order_man.Load(handle);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisor.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisor.mqh"
#endif
//+------------------------------------------------------------------+
