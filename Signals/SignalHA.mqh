//+------------------------------------------------------------------+
//|                                                     SignalHA.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <Indicators\Custom.mqh>
#include <MQLx\Base\Expert\ExpertAdvisorsBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiHA: public CiCustom
  {
public:
                     CiHA(void);
                    ~CiHA(void);
   bool              Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const ENUM_INDICATOR type,const int num_params,const MqlParam &params[],const int buffers);
   double            GetData(const int buffer_num,const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CiHA::CiHA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CiHA::~CiHA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CiHA::Create(const string symbol,const ENUM_TIMEFRAMES period,const ENUM_INDICATOR type,const int num_params,const MqlParam &params[],const int buffers)
  {
   NumBuffers(buffers);
   if(CIndicator::Create(symbol,period,type,num_params,params))
      return Initialize(symbol,period,num_params,params);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CiHA::GetData(const int buffer_num,const int index) const
  {
#ifdef __MQL5__
   return CiCustom::GetData(buffer_num,index);
#else
   return iCustom(m_symbol,m_period,m_params[0].string_value,buffer_num,index);
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SignalHA: public CSignal
  {
protected:
   CiHA             *m_ha;
   CSymbolInfo      *m_symbol;
   string            m_symbol_name;
   int               m_signal_bar;
   double            m_open;
   double            m_close;
public:
   void              SignalHA(const string symbol,const ENUM_TIMEFRAMES timeframe,const int numparams,const MqlParam &params[],const int bar);
   void             ~SignalHA();
   virtual bool      Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL);
   virtual bool      Calculate(void);
   virtual void      Update(void);
   virtual bool      LongCondition(void);
   virtual bool      ShortCondition(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalHA::SignalHA(const string symbol,const ENUM_TIMEFRAMES timeframe,const int numparams,const MqlParam &params[],const int bar)
  {
   m_symbol_name= symbol;
   m_signal_bar = bar;
   m_ha=new CiHA();
   m_ha.Create(symbol,timeframe,IND_CUSTOM,numparams,params,4);
   m_indicators.Add(m_ha);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalHA::~SignalHA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SignalHA::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   if(CSignal::Init(symbol_man,event_man))
     {
      if(CheckPointer(m_symbol_man))
        {
         m_symbol=m_symbol_man.Get();
         if(CheckPointer(m_symbol))
            return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SignalHA::Calculate(void)
  {
#ifdef __MQL5__
   m_open=m_ha.GetData(0,signal_bar);
#else
   m_open=m_ha.GetData(2,signal_bar);
#endif
   m_close=m_ha.GetData(3,signal_bar);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SignalHA::Update(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SignalHA::LongCondition(void)
  {
   return m_open<m_close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SignalHA::ShortCondition(void)
  {
   return m_open>m_close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
