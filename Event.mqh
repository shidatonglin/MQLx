//+------------------------------------------------------------------+
//|                                                        Event.mqh |
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
enum ENUM_ALERT_MODE
  {
   ALERT_MODE_NONE,
   ALERT_MODE_PRINT=1,
   ALERT_MODE_EMAIL=2,
   ALERT_MODE_POPUP=4,
   ALERT_MODE_PUSH=8,
   ALERT_MODE_FTP=16
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_EVENT_TYPE
  {
   EVENT_TYPE_ORDER_SENT,
   EVENT_TYPE_ORDER_ENTRY,
   EVENT_TYPE_ORDER_MODIFY,
   EVENT_TYPE_ORDER_EXIT,
   EVENT_TYPE_ORDER_REVERSE,
   EVENT_TYPE_ERROR,
   EVENT_TYPE_CUSTOM
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEvent : public CObject
  {
protected:
   bool              m_activate;
   ENUM_ALERT_MODE   m_order_sent;
   ENUM_ALERT_MODE   m_order_entry;
   ENUM_ALERT_MODE   m_order_modify;
   ENUM_ALERT_MODE   m_order_exit;
   ENUM_ALERT_MODE   m_order_reverse;
   ENUM_ALERT_MODE   m_error;
public:
                     JEvent(void);
                    ~JEvent(void);
   virtual bool      Add(ENUM_EVENT_TYPE type,string func,string action,string info);
   virtual bool      SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info);
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEvent::JEvent() : m_activate(true),
                   m_order_sent(0),
                   m_order_entry(0),
                   m_order_modify(0),
                   m_order_exit(0),
                   m_order_reverse(0),
                   m_error(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEvent::~JEvent()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEvent::Add(ENUM_EVENT_TYPE type,string func,string action,string info)
  {
   if(!Activate()) return(true);
   ENUM_ALERT_MODE mode=0;
   switch(type)
     {
      case EVENT_TYPE_ORDER_SENT:
        {
         mode=m_order_sent;
         break;
        }
      case EVENT_TYPE_ORDER_ENTRY:
        {
         mode=m_order_entry;
         break;
        }
      case EVENT_TYPE_ORDER_MODIFY:
        {
         mode=m_order_modify;
         break;
        }
      case EVENT_TYPE_ORDER_EXIT:
        {
         mode=m_order_exit;
         break;
        }
      case EVENT_TYPE_ORDER_REVERSE:
        {
         mode=m_order_reverse;
         break;
        }
      case EVENT_TYPE_ERROR:
        {
         mode=m_error;
         break;
        }
     }
   SendAlert(mode,func,action,info);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEvent::SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info)
  {
   if(!mode) return(true);
   string message;
   StringConcatenate(message,func,": ",action," [",info,"]");
   if((bool)(mode  &ALERT_MODE_PRINT))
     {
      Print(message);
      return(true);
     }
   if((bool)(mode  &ALERT_MODE_EMAIL))
     {
      return(SendMail(action,message));
     }
   if((bool)(mode  &ALERT_MODE_POPUP))
     {
      Alert(message);
      return(true);
     }
   if((bool)(mode  &ALERT_MODE_PUSH))
     {
      return(SendNotification(message));
     }
   if((bool)(mode  &ALERT_MODE_FTP))
     {
      return(SendFTP(message));
     }
   return(false);
  }

//+------------------------------------------------------------------+