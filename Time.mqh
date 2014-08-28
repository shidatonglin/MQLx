//+------------------------------------------------------------------+
//|                                                        JTime.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTime : public CObject
  {
protected:
   bool              m_activate;
   datetime          m_time_start;
   ENUM_TIME_FILTER_TYPE m_filter_type;
public:
                     JTime();
                    ~JTime();
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- time functions                    
   virtual bool      Evaluate();
   virtual ENUM_TIME_FILTER_TYPE FilterType() const {return(m_filter_type);}
   virtual void      FilterType(ENUM_TIME_FILTER_TYPE type){m_filter_type=type;}
   virtual datetime  TimeStart() const {return(m_time_start);}
   virtual void      TimeStart(datetime start){m_time_start=start;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTime::JTime() : m_activate(true),
                 m_time_start(0),
                 m_filter_type(TIME_FILTER_INCLUDE)
  {
   m_time_start=TimeCurrent();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTime::~JTime()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTime::Evaluate()
  {
   return(true);
  }
//+------------------------------------------------------------------+