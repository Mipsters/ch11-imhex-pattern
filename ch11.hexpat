#pragma author Mipster
#pragma description irig106-23 ch11 files
#pragma endian little

import std.sys;
import std.mem;

// utils

fn checksum(u128 addr, u128 len, u8 size) {
    u128 sum = 0;
    for(u128 i = 0, i < len, i = i + size) {
        sum += std::mem::read_unsigned(addr + i, size, std::mem::Endian::Little);
    }

    // insure the output is in the correct size
    // 2 ^ (8 * size) - 1 is the max value for a given size
    // so binary &ing it caps the output to the correct size
    return sum & ((1 << (8 * size)) - 1);
};

// 11.2.1.1 e. Data Type Version
enum DataTypeVersion : u8 {
    RESERVED        = 0x00,
    INITIAL_RELEASE = 0x01, // Range Commanders Council [RCC] 106-04
    RCC_106_05      = 0x02,
    RCC_106_07      = 0x03,
    RCC_106_09      = 0x04,
    RCC_106_11      = 0x05,
    RCC_106_13      = 0x06,
    RCC_106_15      = 0x07,
    RCC_106_17      = 0x08,
    RCC_106_19      = 0x09,
    RCC_106_22      = 0x0A
};

// 11.2.1.1 g. Packet Flags
enum DataChecksumType : u8 {
    CHECKSUM_NONE   = 0b00,
    CHECKSUM_8BIT   = 0b01,
    CHECKSUM_16BIT  = 0b10,
    CHECKSUM_32BIT  = 0b11,
};

fn checksumToLen(DataChecksumType type) {
    match(type) {
        (DataChecksumType::CHECKSUM_NONE): return 0;
        (DataChecksumType::CHECKSUM_8BIT): return 1;
        (DataChecksumType::CHECKSUM_16BIT): return 2;
        (DataChecksumType::CHECKSUM_32BIT): return 4;
    }
};

enum SecondaryDateFormat : u8 {
    CHAPTER_4   = 0b00,
    IEEE_1588   = 0b01,
    ERTC        = 0b10,
    RESERVED    = 0b11,
};

enum SecondaryTimeSource : u8 {
    PACKET_RTC          = 0b0,
    SECONDARY_HEADER    = 0b1,
};

bitfield PacketFlags {
    DataChecksumType dataChecksumType   : 2; // 0-1
    SecondaryDateFormat scndryTimeFmt   : 2; // 2-3
    bool dataOverflowError              : 1; // 4
    bool rtcSyncError                   : 1; // 5
    SecondaryTimeSource iptsTimeSource  : 1; // 6
    bool secondaryHeaderPresence        : 1; // 7
};

// Table 11-4 Data Type Names and Descriptions
enum HeaderDataType : u8 {
    COMPUTER_0              = 0x00,
    USER_DEFINED            = 0x00,
    COMPUTER_1              = 0x01,
    TMATS                   = 0x01,
    COMPUTER_2              = 0x02,
    RECORDING_EVENT         = 0x02,
    COMPUTER_3              = 0x03,
    RECORDING_INDEX         = 0x03,
    COMPUTER_4              = 0x04,
    STREAMING_CONFIG        = 0x04,
    COMPUTER_5              = 0x05, // Reserved for future use
    COMPUTER_6              = 0x06, // Reserved for future use
    COMPUTER_7              = 0x07, // Reserved for future use
    PCM_FMT_0               = 0x08, // Reserved for future use
    PCM_FMT_1               = 0x09,
    PCM                     = 0x09,
    PCM_FMT_2               = 0x0A,
    PCM_DQE                 = 0x0A,
    PCM_FMT_3               = 0x0B, // Reserved for future use
    PCM_FMT_4               = 0x0C, // Reserved for future use
    PCM_FMT_5               = 0x0D, // Reserved for future use
    PCM_FMT_6               = 0x0E, // Reserved for future use
    PCM_FMT_7               = 0x0F, // Reserved for future use
    TIME_FMT_0              = 0x10, // Reserved for future use
    TIME_FMT_1              = 0x11,
    IRIG_TIME               = 0x11,
    TIME_FMT_2              = 0x12,
    NETWORK_TIME            = 0x12,
    TIME_FMT_3              = 0x13, // Reserved for future use
    TIME_FMT_4              = 0x14, // Reserved for future use
    TIME_FMT_5              = 0x15, // Reserved for future use
    TIME_FMT_6              = 0x16, // Reserved for future use
    TIME_FMT_7              = 0x17, // Reserved for future use
    MIL_1553_FMT_0          = 0x18,
    MIL_1553_FMT_1          = 0x19,
    MIL_1553_FMT_2          = 0x1A,
    MIL_16PP194             = 0x1A,
    MIL_1553_FMT_3          = 0x1B, // Reserved for future use
    MIL_1553_FMT_4          = 0x1C, // Reserved for future use
    MIL_1553_FMT_5          = 0x1D, // Reserved for future use
    MIL_1553_FMT_6          = 0x1E, // Reserved for future use
    MIL_1553_FMT_7          = 0x1F, // Reserved for future use
    ANALOG_FMT_0            = 0x20, // Reserved for future use
    ANALOG_FMT_1            = 0x21,
    ANALOG                  = 0x21,
    ANALOG_FMT_2            = 0x22,
    ANALOG_FMT_3            = 0x23,
    ANALOG_FMT_4            = 0x24,
    ANALOG_FMT_5            = 0x25, // Reserved for future use
    ANALOG_FMT_6            = 0x26, // Reserved for future use
    ANALOG_FMT_7            = 0x27, // Reserved for future use
    DISCRETE_FMT_0          = 0x28, // Reserved for future use
    DISCRETE_FMT_1          = 0x29,
    DISCRETE                = 0x29,
    DISCRETE_FMT_2          = 0x2A, // Reserved for future use
    DISCRETE_FMT_3          = 0x2B, // Reserved for future use
    DISCRETE_FMT_4          = 0x2C, // Reserved for future use
    DISCRETE_FMT_5          = 0x2D, // Reserved for future use
    DISCRETE_FMT_6          = 0x2E, // Reserved for future use
    DISCRETE_FMT_7          = 0x2F, // Reserved for future use
    MESSAGE_FMT_0           = 0x30,
    MESSAGE                 = 0x30,
    MESSAGE_FMT_1           = 0x31, // Reserved for future use
    MESSAGE_FMT_2           = 0x32, // Reserved for future use
    MESSAGE_FMT_3           = 0x33, // Reserved for future use
    MESSAGE_FMT_4           = 0x34, // Reserved for future use
    MESSAGE_FMT_5           = 0x35, // Reserved for future use
    MESSAGE_FMT_6           = 0x36, // Reserved for future use
    MESSAGE_FMT_7           = 0x37, // Reserved for future use
    ARINC_429_FMT_0         = 0x38,
    ARINC_429_DATA          = 0x38,
    ARINC_429_FMT_1         = 0x39, // Reserved for future use
    ARINC_429_FMT_2         = 0x3A, // Reserved for future use
    ARINC_429_FMT_3         = 0x3B, // Reserved for future use
    ARINC_429_FMT_4         = 0x3C, // Reserved for future use
    ARINC_429_FMT_5         = 0x3D, // Reserved for future use
    ARINC_429_FMT_6         = 0x3E, // Reserved for future use
    ARINC_429_FMT_7         = 0x3F, // Reserved for future use
    VIDEO_FMT_0             = 0x40, // Legacy
    VIDEO_MPEG_2            = 0x40, // Legacy
    VIDEO_FMT_1             = 0x41, // Deprecated
    VIDEO_FMT_2             = 0x42,
    VIDEO_H264              = 0x42,
    VIDEO_FMT_3             = 0x43, // Deprecated
    VIDEO_FMT_4             = 0x44,
    VIDEO_MJPEG_2000        = 0x44,
    VIDEO_FMT_5             = 0x45, // Reserved for future use
    VIDEO_FMT_6             = 0x46, // Reserved for future use
    VIDEO_FMT_7             = 0x47, // Reserved for future use
    IMAGE_FMT_0             = 0x48,
    IMAGE_DATA              = 0x48,
    IMAGE_FMT_1             = 0x49,
    IMAGE_STILL             = 0x49,
    IMAGE_FMT_2             = 0x4A,
    IMAGE_DYNAMIC           = 0x4A,
    IMAGE_FMT_3             = 0x4B, // Reserved for future use
    IMAGE_FMT_4             = 0x4C, // Reserved for future use
    IMAGE_FMT_5             = 0x4D, // Reserved for future use
    IMAGE_FMT_6             = 0x4E, // Reserved for future use
    IMAGE_FMT_7             = 0x4F, // Reserved for future use
    UART_FMT_0              = 0x50,
    UART_DATA               = 0x50,
    UART_FMT_1              = 0x51, // Reserved for future use
    UART_FMT_2              = 0x52, // Reserved for future use
    UART_FMT_3              = 0x53, // Reserved for future use
    UART_FMT_4              = 0x54, // Reserved for future use
    UART_FMT_5              = 0x55, // Reserved for future use
    UART_FMT_6              = 0x56, // Reserved for future use
    UART_FMT_7              = 0x57, // Reserved for future use
    IEEE_1394_FMT_0         = 0x58,
    IEEE_1394_TRANSACTION   = 0x58,
    IEEE_1394_FMT_1         = 0x59,
    IEEE_1394_PHYSICAL      = 0x59,
    IEEE_1394_FMT_2         = 0x5A, // Reserved for future use
    IEEE_1394_FMT_3         = 0x5B, // Reserved for future use
    IEEE_1394_FMT_4         = 0x5C, // Reserved for future use
    IEEE_1394_FMT_5         = 0x5D, // Reserved for future use
    IEEE_1394_FMT_6         = 0x5E, // Reserved for future use
    IEEE_1394_FMT_7         = 0x5F, // Reserved for future use
    PARALLEL_FMT_0          = 0x60,
    PARALLEL_DATA           = 0x60,
    PARALLEL_FMT_1          = 0x61, // Reserved for future use
    PARALLEL_FMT_2          = 0x62, // Reserved for future use
    PARALLEL_FMT_3          = 0x63, // Reserved for future use
    PARALLEL_FMT_4          = 0x64, // Reserved for future use
    PARALLEL_FMT_5          = 0x65, // Reserved for future use
    PARALLEL_FMT_6          = 0x66, // Reserved for future use
    PARALLEL_FMT_7          = 0x67, // Reserved for future use
    ETHERNET_FMT_0          = 0x68,
    ETHERNET_FMT_1          = 0x69,
    ETHERNET_A664           = 0x69,
    ETHERNET_FMT_2          = 0x6A, // Reserved for future use
    ETHERNET_FMT_3          = 0x6B, // Reserved for future use
    ETHERNET_FMT_4          = 0x6C, // Reserved for future use
    ETHERNET_FMT_5          = 0x6D, // Reserved for future use
    ETHERNET_FMT_6          = 0x6E, // Reserved for future use
    ETHERNET_FMT_7          = 0x6F, // Reserved for future use
    TSPI_FMT_0              = 0x70,
    TSPI_FMT_1              = 0x71,
    TSPI_FMT_2              = 0x72,
    TSPI_FMT_3              = 0x73, // Reserved for future use
    TSPI_FMT_4              = 0x74, // Reserved for future use
    TSPI_FMT_5              = 0x75, // Reserved for future use
    TSPI_FMT_6              = 0x76, // Reserved for future use
    TSPI_FMT_7              = 0x77, // Reserved for future use
    CAN                     = 0x78,
    FC_FMT_0                = 0x79,
    FC_FMT_1                = 0x7A,
    FC_FMT_2                = 0x7B, // Reserved for future use
    FC_FMT_3                = 0x7C, // Reserved for future use
    FC_FMT_4                = 0x7D, // Reserved for future use
    FC_FMT_5                = 0x7E, // Reserved for future use
    FC_FMT_6                = 0x7F, // Reserved for future use
    FC_FMT_7                = 0x80, // Reserved for future use
};

// 11.2.1.2 Packet Secondary Header
struct PacketSecondaryHeader {
    u128 headerStartPos = $;
    
    u8      abyTime[8];   ///< Time (start secondary header)
    u16     uReserved;    //
    u16     uSecChecksum; ///< Secondary Header Checksum
    
    u128 checksumOut = checksum(headerStartPos, $ - headerStartPos - sizeof(uSecChecksum), sizeof(uSecChecksum));
    
    str outStr = "Secondary Packet Header: Checksum doesn't match\n location: {}, width: {}, calculated: {:x}, expected: {:x}";
    outStr = std::format(outStr, outStr, headerStartPos, sizeof(uSecChecksum), checksumOut,uSecChecksum);
    std::assert(uSecChecksum == checksumOut, outStr);
};

// 11.2.1.1 Packet Header, Version 1
struct PacketHeader {
    u128 headerStartPos = $;
    
    u16             uSync;          ///< Packet Sync Pattern
    std::assert(uSync == 0xEB25, "Packet Header: bad sync value");
    u16             uChID;          ///< Channel ID
    u32             ulPacketLen;    ///< Total packet length
    u32             ulDataLen;      ///< Data length
    DataTypeVersion ubyHdrVer;      ///< Header Version
    // seqnum need to be 1 more (with rollover) then the value of the prev packet in channel
    u8              ubySeqNum;      ///< Sequence Number
    PacketFlags     ubyPacketFlags; ///< PacketFlags
    
    str outStr = "Packet Header: IPTS it source is secondary header but secondary header isn't present";
    std::assert(!ubyPacketFlags.iptsTimeSource || ubyPacketFlags.iptsTimeSource && ubyPacketFlags.secondaryHeaderPresence, outStr);
    
    HeaderDataType  ubyDataType;    ///< Data type
    u8              aubyRefTime[6]; ///< Reference time
    u16             uChecksum;      ///< Header Checksum
    
    u128 checksumOut = checksum(headerStartPos, $ - headerStartPos - sizeof(uChecksum), sizeof(uChecksum));
    
    outStr = "Packet Header: Checksum doesn't match\n location: {}, width: {}, calculated: {:x}, expected: {:x}";
    outStr = std::format(outStr, headerStartPos, sizeof(uChecksum), checksumOut, uChecksum);
    std::assert(uChecksum == checksumOut, outStr);
    
    if (ubyPacketFlags.secondaryHeaderPresence) {
        PacketSecondaryHeader secondaryHeader;
    }
};


// Packets

namespace COMPUTER_GENERATED_DATA_PACKETS {

    namespace FMT_0 {
        struct CSDW {
            u32 userDefined;
        };
    }
    
    namespace FMT_1 {

        // 11.2.7.2 a. RCC 106 Version (RCCVER)
        enum Rcc106Version : u8 {
            RCC106_07 = 0x07,
            RCC106_09 = 0x08,
            RCC106_11 = 0x09,
            RCC106_13 = 0x0A,
            RCC106_15 = 0x0B,
            RCC106_17 = 0x0C,
            RCC106_19 = 0x0D,
            RCC106_22 = 0x0E,
        };
        
        // 11.2.7.2 a. FRMT
        enum SetupRecordFormat : u8 {
            ASCII   = 0b0,
            XML     = 0b1,
        };
        
        // 11.2.7.2 a. Format 1 Channel-Specific Data Word
        bitfield CSDW {
            Rcc106Version       rccVer  : 7;
            bool                srcc    : 1;
            SetupRecordFormat   recFmt  : 1;
            padding                     : 21;
        };
    }
}

namespace TIME {
    
    namespace FMT_1 {
        // 11.2.3.2 a. Time Source
        enum TimeSource : u8 {
            INTERNAL        = 0x0,
            EXTERNAL        = 0x1,
            RMM_INTERNAL    = 0x2,
            NONE            = 0xF,
        };

        // 11.2.3.2 a. Time Format
        enum TimeFormat : u8 {
            IRIG_B      = 0x0,
            IRIG_A      = 0x1,
            IRIG_G      = 0x2,
            RTC         = 0x3,
            GPS_UTC     = 0x4,
            GPS_NATIVE  = 0x5,
            NONE        = 0xF,
        };

        // 11.2.3.2 a. Date
        enum DateFormat : u8 {
            IRIG_DAY    = 0b0,
            MONTH_N_DAY = 0b1,
        };

        // 11.2.3.2 a. IRIG Time Source
        enum IrigTimeSource : u8 {
            FREEWHEELING                = 0b0000,
            FREEWHEELING_FROM_TIME_CMD  = 0b0001,
            FREEWHEELING_FROM_RMM_TIME  = 0b0010,
            LOCKED_TO_IRIG_SIGNAL       = 0b0011,
            LOCKED_TO_GPS               = 0b0100,
            LOCKED_TO_NTP               = 0b0101,
            LOCKED_TO_PTP               = 0b0110,
            LOCKED_TO_EMBEDDED_TIME     = 0b0111, // PCM / MIL-STD-1553
        };

        // 11.2.3.2 Time Data Packets, Format 1
        bitfield CSDW {
            TimeSource src          : 4;
            TimeFormat fmt          : 4;
            // Date
            bool isLeapYear         : 1;
            DateFormat dateFormat   : 1;
            padding                 : 2; // Reserved
            // Date end
            IrigTimeSource its      : 4;
            padding                 : 16;
        };

        // 11.2.3.2 a. Figure 11-13
        bitfield BodyDay {
            Tmn : 4;
            Hmn : 4;
            Sn  : 4;
            TSn : 3;
            padding : 1;
            Mn  : 4;
            TMn : 2;
            padding : 2;
            Hn  : 4;
            THn : 2;
            padding : 2;
            Dn  : 4;
            TDn : 4;
            HDn : 2;
            padding: 6;
        };

        // 11.2.3.2 a. Figure 11-14
        bitfield BodyDayMonthYear {
            Tmn : 4;
            Hmn : 4;
            Sn  : 4;
            TSn : 3;
            padding : 1;
            Mn  : 4;
            TMn : 2;
            padding : 2;
            Hn  : 4;
            THn : 2;
            padding : 2;
            Dn  : 4;
            TDn : 4;
            On  : 4;
            Ton : 1;
            padding : 3;
            Yn  : 4;
            TYn : 4;
            HYn : 4;
            OYn : 2;
            padding : 2;
        };
    }
}

namespace MIL_1553 {

    namespace FMT_1 {

        enum TimeTagBits : u8 {
            LAST_WORD_LAST_BIT  = 0b00,
            LAST_WORD_FIRST_BIT = 0b01,
            FIRST_WORD_LAST_BIT = 0b10, // (command word)
        };

        // 11.2.4.2 a. MIL-STD-1553 Packet Channel-Specific Data
        bitfield CSDW {
            msgCount        : 24;
            padding         : 6;
            TimeTagBits ttb : 2;
        };

        enum BusID : u8 {
            CHANNEL_A = 0b0,
            CHANNEL_B = 0b1,
        };

        // 11.2.4.2 c. (2) Block Status Word
        bitfield BlockStatusWord {
            padding                 : 3;
            bool invalidWord        : 1;
            bool syncTypeError      : 1;
            bool wordCountError     : 1;
            padding                 : 3;
            bool responseTimeOut    : 1;
            bool formatError        : 1;
            bool isRtToRt           : 1;
            bool messageError       : 1;
            BusID busID             : 1;
            padding                 : 2;
        };

        // 11.2.4.2 c. (2) Gap Times Word
        struct GapTime {
            u8 gap1;
            u8 gap2;
        };

        // 11.2.4.2 c. (2) Intra-Packet Data Header
        struct IntraDataHeader {
            BlockStatusWord blockStatusWord;
            GapTime gapTimeWord;
            u16 lengthWord;
        };

        enum TransmissionDirection : u8 {
            RECEIVE = 0b0,
            TRANSMIT = 0b1,
        };

        // MIL-STD-1553C 4.3.3.5 FIGURE 3
        // notice the struct is reverse for big endian support
        bitfield CommandWord {
            dataWordsNum                : 5;
            subAddress                  : 5;
            TransmissionDirection dir   : 1;
            remoteTerminal              : 5;
        };

        fn dataWordsFromCW(auto dataWordsNum) {
            match(dataWordsNum) {
                (0): return 32;
                (1): return 31;
            }
            return dataWordsNum;
        };

        // MIL-STD-1553C 4.3.3.5 FIGURE 3
        // notice the struct is reverse for big endian support
        bitfield StatusWord {
            bool terminalFlag           : 1;
            // DYNAMIC BUS CONTROL ACCEPTANCE
            bool dbca                   : 1;
            bool subsystemFlag          : 1;
            bool busy                   : 1;
            bool broadcastCmdReceived   : 1;
            padding                     : 3;
            bool serviceRequest         : 1;
            bool instrumentation        : 1;
            bool messageError           : 1;
            remoteTerminal              : 5;
        };

        // MIL-STD-1553C 4.3.3.6.3
        struct RT2RTBody <auto byteCount> {
            u128 bodyStart = $;

            if ($ - bodyStart + sizeof(CommandWord) <= byteCount)
                CommandWord receiveCommandWord;
            
            if ($ - bodyStart + sizeof(CommandWord) <= byteCount)
                CommandWord transmitCommandWord;
            
            if ($ - bodyStart + sizeof(StatusWord) <= byteCount)
                StatusWord transmitStatusWord;
            
            str outStr = std::format("MIL_1553::FMT_1: rt2rt transmit command and status word need to share rt\nlocation 0x{:x}", bodyStart);
            std::assert(transmitCommandWord.remoteTerminal == transmitStatusWord.remoteTerminal, outStr);
            
            u8 realDataWordsNum = MIL_1553::FMT_1::dataWordsFromCW(transmitCommandWord.dataWordsNum);
            u128 startLoc = $;
            u16 data[while(($ - startLoc < realDataWordsNum * 2) && ($ - bodyStart < byteCount))];

            if ($ - bodyStart + sizeof(StatusWord) <= byteCount)
                StatusWord receiveStatusWord;
            
            outStr = std::format("MIL_1553::FMT_1: rt2rt receive command and status word need to share rt\nlocation 0x{:x}", bodyStart);
            std::assert(transmitCommandWord.remoteTerminal == transmitStatusWord.remoteTerminal, outStr);
            outStr = std::format("MIL_1553::FMT_1: rt2rt command words need to have the same length\nlocation 0x{:x}", bodyStart);
            std::assert(receiveCommandWord.dataWordsNum == transmitCommandWord.dataWordsNum, outStr);
        };

        // MIL-STD-1553C 4.3.3.6.1
        // MIL-STD-1553C 4.3.3.6.2
        struct NonRT2RTBody <auto byteCount> {
            u128 bodyStart = $;

            if ($ - bodyStart + sizeof(CommandWord) <= byteCount)
                CommandWord commandWord;

            if (commandWord.dir == TransmissionDirection::TRANSMIT) {
                if ($ - bodyStart + sizeof(StatusWord) <= byteCount) {
                    StatusWord statusWord;

                    str outStr = std::format("MIL_1553::FMT_1: command and status word need to share rt\nlocation 0x{:x}", bodyStart);
                    std::assert(commandWord.remoteTerminal == statusWord.remoteTerminal, outStr);
                }
            }

            if (commandWord.subAddress == 0 || commandWord.subAddress == 31) {
                std::print("ModeCode\n");
                if (commandWord.dataWordsNum & 0b10000) {
                    u16 data;
                }
            } else {
            u8 realDataWordsNum = MIL_1553::FMT_1::dataWordsFromCW(commandWord.dataWordsNum);
            u128 startLoc = $;
            u16 data[while(($ - startLoc < realDataWordsNum * 2) && ($ - bodyStart < byteCount))];
            }
            
            if (commandWord.dir == TransmissionDirection::RECEIVE) {
                if ($ - bodyStart + sizeof(StatusWord) <= byteCount) {
                    StatusWord statusWord;

                    str outStr = std::format("MIL_1553::FMT_1: command and status word need to share rt\nlocation 0x{:x}", bodyStart);
                    std::assert(commandWord.remoteTerminal == statusWord.remoteTerminal, outStr);
                }
            }
        };
        
        // 11.2.4.2 d. Packet Format
        struct IntraPacket {
            u64 IPTS;
            IntraDataHeader header;
            
            if (header.blockStatusWord.isRtToRt)
                RT2RTBody<header.lengthWord> body;
            else
                NonRT2RTBody<header.lengthWord> body;
            
            str outStr = "MIL_1553::FMT_1: body has wrong size\nlocation: 0x{:x}, expected: {}, found: {}";
            outStr = std::format(outStr, addressof(IPTS), header.lengthWord, sizeof(body));
            std::assert_warn(sizeof(body) == header.lengthWord, outStr);
        };
    }
}

// 11.2.1.3 Packet Body, Version 1
struct Packet {
    u128 packetStart = $;
    
    PacketHeader header;

    u128 packetBodyStart = $;
    
    match(header.ubyDataType) {
        (HeaderDataType::COMPUTER_0): {
            COMPUTER_GENERATED_DATA_PACKETS::FMT_0::CSDW csdw;
            u8 data[header.ulDataLen - sizeof(csdw)];
        }
        (HeaderDataType::COMPUTER_1): {
            COMPUTER_GENERATED_DATA_PACKETS::FMT_1::CSDW csdw;
            u8 data[header.ulDataLen - sizeof(csdw)];
        }
        (HeaderDataType::IRIG_TIME): {
            TIME::FMT_1::CSDW csdw;
            match(csdw.dateFormat) {
                (TIME::FMT_1::DateFormat::IRIG_DAY): TIME::FMT_1::BodyDay data;
                (TIME::FMT_1::DateFormat::MONTH_N_DAY): TIME::FMT_1::BodyDayMonthYear data;
            }
        }
        (HeaderDataType::MIL_1553_FMT_1): {
            MIL_1553::FMT_1::CSDW csdw;
            
            // there are issues with this currently
            MIL_1553::FMT_1::IntraPacket data[csdw.msgCount];
            //u8 data[header.ulDataLen - sizeof(csdw)];
        }
        (_): {
            std::assert_warn(false, std::format("Unsupported data type at 0x{:x}", packetStart));
            u8 data[header.ulDataLen] [[comment("default implementation")]];
        }
    }


    // 11.2.1.4 Packet Trailer, Version 1
    u128 checksumLen = checksumToLen(header.ubyPacketFlags.dataChecksumType);
    
    // ($ - packetStart + checksumLen) - packet content size
    // ($ - packetStart + checksumLen) % 4 - remainder, 0-3
    // 4 - ($ - packetStart + checksumLen) % 4 - number of bytes missing to complete to nearest multipicant of 4, 1-4
    // (4 - ($ - packetStart + checksumLen) % 4) & 3 - replaces the value of 4 with 0 in the previouse range, 0-3
    u8 filler[(4 - ($ - packetStart + checksumLen) % 4) & 3];
    
    if (header.ubyPacketFlags.dataChecksumType != DataChecksumType::CHECKSUM_NONE)
        u128 checksumOut = checksum(packetBodyStart, $ - packetBodyStart, checksumLen);
    
    match(header.ubyPacketFlags.dataChecksumType) {
        (DataChecksumType::CHECKSUM_8BIT): u8 uChecksum;
        (DataChecksumType::CHECKSUM_16BIT): u16 uChecksum;
        (DataChecksumType::CHECKSUM_32BIT): u32 uChecksum;
    }
    
    if (header.ubyPacketFlags.dataChecksumType != DataChecksumType::CHECKSUM_NONE) {
        str outStr = "Packet Trailer: Checksum doesn't match\n location: 0x{:x}, width: {}, calculated: {:x}, expected: {:x}";
        outStr = std::format(outStr, packetStart, checksumLen, checksumOut, uChecksum);
        std::assert_warn(uChecksum == checksumOut, outStr);
    }
    
    // maybe this should be before the regular filler, I don't know :(
    u8 packetFiller[header.ulPacketLen - ($ - packetStart)];
};

Packet packet[while($ < std::mem::size())] @ 0x00;
