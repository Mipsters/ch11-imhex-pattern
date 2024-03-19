// irig106-23 ch11

import std.sys;
import std.mem;

// utils

fn checksum(u128 addr, u128 len, u8 size) {
    u16 sum = 0;
    for(u128 i = 0, i < len, i = i + size) {
        sum += std::mem::read_unsigned(addr + i, 2, std::mem::Endian::Little);
    }
    return sum;
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
    auto headerStartPos = $;
    
    u8      abyTime[8];   ///< Time (start secondary header)
    u16     uReserved;    //
    u16     uSecChecksum; ///< Secondary Header Checksum
    
    std::assert(
        uSecChecksum == checksum(headerStartPos, $ - headerStartPos - 2, 2),
        "Secondary Packet Header: Checksum doesn't match"
    );
};

// 11.2.1.1 Packet Header, Version 1
struct PacketHeader {
    auto headerStartPos = $;
    
    u16             uSync;          ///< Packet Sync Pattern
    std::assert(uSync == 0xEB25, "Packet Header: bad sync value");
    u16             uChID;          ///< Channel ID
    u32             ulPacketLen;    ///< Total packet length
    u32             ulDataLen;      ///< Data length
    DataTypeVersion ubyHdrVer;      ///< Header Version
    // seqnum need to be 1 more (with rollover) then the value of the prev packcet in channel
    u8              ubySeqNum;      ///< Sequence Number
    PacketFlags     ubyPacketFlags; ///< PacketFlags
    std::assert(
        !ubyPacketFlags.iptsTimeSource || ubyPacketFlags.iptsTimeSource && ubyPacketFlags.secondaryHeaderPresence,
        "Packet Header: IPTS it source is secondary header but secondary header isn't present");
    
    HeaderDataType  ubyDataType;    ///< Data type
    u8              aubyRefTime[6]; ///< Reference time
    u16             uChecksum;      ///< Header Checksum
    
    std::assert(
        uChecksum == checksum(headerStartPos, $ - headerStartPos - 2, 2),
        "Packet Header: Checksum doesn't match"
    );
    
    if (ubyPacketFlags.secondaryHeaderPresence) {
        PacketSecondaryHeader secondaryHeader;
    }
};

// Packets

struct COMPUTER_GENERATED_DATA_PACKETS_FORMAT_0 {};

struct COMPUTER_GENERATED_DATA_PACKETS_FORMAT_1 {

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

    enum SetupRecordFormat : u8 {
        ASCII   = 0b0,
        XML     = 0b1,
    };

    Rcc106Version       rccVer  : 7;
    bool                srcc    : 1;
    SetupRecordFormat   recFmt  : 1;
    padding                     : 21;
};

// 11.2.1.3 Packet Body, Version 1
struct Packet {
    PacketHeader header;

    match(header.ubyDataType) {
        (HeaderDataType::COMPUTER_1): a;
    }
    IPTS
};

Packet packet @ 0x00;