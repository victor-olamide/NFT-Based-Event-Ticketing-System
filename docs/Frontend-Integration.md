# Frontend Integration Guide

## Overview

This guide provides comprehensive instructions for integrating the NFT Event Ticketing System into frontend applications using React, Next.js, and Web3 libraries.

## Table of Contents

- [Setup and Installation](#setup-and-installation)
- [Web3 Configuration](#web3-configuration)
- [Component Examples](#component-examples)
- [State Management](#state-management)
- [Error Handling](#error-handling)
- [UI/UX Best Practices](#uiux-best-practices)

## Setup and Installation

### Dependencies

```json
{
  "dependencies": {
    "@rainbow-me/rainbowkit": "^1.0.0",
    "@wagmi/core": "^1.4.0",
    "ethers": "^6.4.0",
    "next": "13.4.0",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "wagmi": "^1.4.0",
    "viem": "^1.0.0"
  },
  "devDependencies": {
    "@types/react": "18.2.0",
    "typescript": "5.0.0"
  }
}
```

### Installation

```bash
npm install @rainbow-me/rainbowkit wagmi viem ethers
```

## Web3 Configuration

### Wagmi Configuration

```typescript
// lib/wagmi.ts
import { getDefaultWallets } from '@rainbow-me/rainbowkit';
import { configureChains, createConfig } from 'wagmi';
import { base, baseGoerli } from 'wagmi/chains';
import { publicProvider } from 'wagmi/providers/public';
import { alchemyProvider } from 'wagmi/providers/alchemy';

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [base, baseGoerli],
  [
    alchemyProvider({ apiKey: process.env.NEXT_PUBLIC_ALCHEMY_API_KEY! }),
    publicProvider(),
  ]
);

const { connectors } = getDefaultWallets({
  appName: 'NFT Event Ticketing',
  projectId: process.env.NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID!,
  chains,
});

export const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
  webSocketPublicClient,
});

export { chains };
```

### Contract Configuration

```typescript
// lib/contracts.ts
import { Address } from 'viem';

export const CONTRACT_ADDRESSES = {
  [base.id]: {
    eventTicket: process.env.NEXT_PUBLIC_EVENT_TICKET_ADDRESS as Address,
    marketplace: process.env.NEXT_PUBLIC_MARKETPLACE_ADDRESS as Address,
  },
  [baseGoerli.id]: {
    eventTicket: process.env.NEXT_PUBLIC_EVENT_TICKET_ADDRESS_TESTNET as Address,
    marketplace: process.env.NEXT_PUBLIC_MARKETPLACE_ADDRESS_TESTNET as Address,
  },
} as const;

export const getContractAddress = (chainId: number, contract: 'eventTicket' | 'marketplace') => {
  return CONTRACT_ADDRESSES[chainId as keyof typeof CONTRACT_ADDRESSES]?.[contract];
};
```

## Component Examples

### Event Creation Component

```typescript
// components/CreateEvent.tsx
import { useState } from 'react';
import { useContractWrite, useWaitForTransaction } from 'wagmi';
import { parseEther } from 'viem';
import { eventTicketABI } from '../lib/abis';
import { getContractAddress } from '../lib/contracts';

interface CreateEventProps {
  onEventCreated?: (eventId: string) => void;
}

export function CreateEvent({ onEventCreated }: CreateEventProps) {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    venue: '',
    date: '',
    totalTickets: '',
    ticketPrice: '',
    maxTransferPrice: '',
    transferable: true,
  });

  const { data, write, isLoading } = useContractWrite({
    address: getContractAddress(8453, 'eventTicket'),
    abi: eventTicketABI,
    functionName: 'createEvent',
  });

  const { isLoading: isConfirming } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess: (receipt) => {
      const eventCreatedLog = receipt.logs.find(
        (log) => log.topics[0] === '0x...' // EventCreated event signature
      );
      if (eventCreatedLog && onEventCreated) {
        const eventId = eventCreatedLog.topics[1];
        onEventCreated(eventId);
      }
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    const eventDate = Math.floor(new Date(formData.date).getTime() / 1000);
    
    write({
      args: [
        formData.name,
        formData.description,
        BigInt(eventDate),
        formData.venue,
        BigInt(formData.totalTickets),
        parseEther(formData.ticketPrice),
        parseEther(formData.maxTransferPrice),
        formData.transferable,
      ],
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700">
          Event Name
        </label>
        <input
          type="text"
          value={formData.name}
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          required
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">
          Description
        </label>
        <textarea
          value={formData.description}
          onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          rows={3}
          required
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">
          Venue
        </label>
        <input
          type="text"
          value={formData.venue}
          onChange={(e) => setFormData({ ...formData, venue: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          required
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">
          Event Date
        </label>
        <input
          type="datetime-local"
          value={formData.date}
          onChange={(e) => setFormData({ ...formData, date: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          required
        />
      </div>
      
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700">
            Total Tickets
          </label>
          <input
            type="number"
            value={formData.totalTickets}
            onChange={(e) => setFormData({ ...formData, totalTickets: e.target.value })}
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
            min="1"
            required
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700">
            Ticket Price (ETH)
          </label>
          <input
            type="number"
            step="0.001"
            value={formData.ticketPrice}
            onChange={(e) => setFormData({ ...formData, ticketPrice: e.target.value })}
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
            min="0"
            required
          />
        </div>
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">
          Max Transfer Price (ETH)
        </label>
        <input
          type="number"
          step="0.001"
          value={formData.maxTransferPrice}
          onChange={(e) => setFormData({ ...formData, maxTransferPrice: e.target.value })}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          min="0"
          required
        />
      </div>
      
      <div className="flex items-center">
        <input
          type="checkbox"
          checked={formData.transferable}
          onChange={(e) => setFormData({ ...formData, transferable: e.target.checked })}
          className="h-4 w-4 text-blue-600 border-gray-300 rounded"
        />
        <label className="ml-2 block text-sm text-gray-900">
          Allow ticket transfers
        </label>
      </div>
      
      <button
        type="submit"
        disabled={isLoading || isConfirming}
        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
      >
        {isLoading || isConfirming ? 'Creating Event...' : 'Create Event'}
      </button>
    </form>
  );
}
```

### Ticket Purchase Component

```typescript
// components/PurchaseTicket.tsx
import { useState } from 'react';
import { useContractWrite, useWaitForTransaction, useContractRead } from 'wagmi';
import { formatEther, parseEther } from 'viem';
import { eventTicketABI } from '../lib/abis';
import { getContractAddress } from '../lib/contracts';

interface PurchaseTicketProps {
  eventId: string;
  onTicketPurchased?: (ticketId: string) => void;
}

export function PurchaseTicket({ eventId, onTicketPurchased }: PurchaseTicketProps) {
  const [seatNumber, setSeatNumber] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // Read event details
  const { data: eventData } = useContractRead({
    address: getContractAddress(8453, 'eventTicket'),
    abi: eventTicketABI,
    functionName: 'events',
    args: [BigInt(eventId)],
  });

  const { data, write } = useContractWrite({
    address: getContractAddress(8453, 'eventTicket'),
    abi: eventTicketABI,
    functionName: 'mintTicket',
  });

  const { isLoading: isConfirming } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess: (receipt) => {
      const ticketMintedLog = receipt.logs.find(
        (log) => log.topics[0] === '0x...' // TicketMinted event signature
      );
      if (ticketMintedLog && onTicketPurchased) {
        const ticketId = ticketMintedLog.topics[1];
        onTicketPurchased(ticketId);
      }
      setIsLoading(false);
    },
  });

  const generateQRCode = (eventId: string, seatNumber: string) => {
    return `EVENT_${eventId}_SEAT_${seatNumber}_${Date.now()}`;
  };

  const handlePurchase = async () => {
    if (!eventData || !seatNumber) return;
    
    setIsLoading(true);
    const qrCode = generateQRCode(eventId, seatNumber);
    
    write({
      args: [BigInt(eventId), BigInt(seatNumber), qrCode],
      value: eventData.ticketPrice,
    });
  };

  if (!eventData) {
    return <div>Loading event details...</div>;
  }

  const isEventActive = eventData.isActive;
  const ticketsAvailable = eventData.totalTickets - eventData.ticketsSold;
  const ticketPrice = formatEther(eventData.ticketPrice);

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <h3 className="text-lg font-medium text-gray-900 mb-4">
        Purchase Ticket
      </h3>
      
      <div className="space-y-4">
        <div>
          <p className="text-sm text-gray-600">Event: {eventData.name}</p>
          <p className="text-sm text-gray-600">Venue: {eventData.venue}</p>
          <p className="text-sm text-gray-600">
            Price: {ticketPrice} ETH
          </p>
          <p className="text-sm text-gray-600">
            Available: {ticketsAvailable.toString()} tickets
          </p>
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700">
            Seat Number
          </label>
          <input
            type="number"
            value={seatNumber}
            onChange={(e) => setSeatNumber(e.target.value)}
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
            min="1"
            max={eventData.totalTickets.toString()}
            required
          />
        </div>
        
        <button
          onClick={handlePurchase}
          disabled={!isEventActive || ticketsAvailable === 0n || !seatNumber || isLoading || isConfirming}
          className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 disabled:opacity-50"
        >
          {isLoading || isConfirming ? 'Purchasing...' : `Purchase Ticket (${ticketPrice} ETH)`}
        </button>
        
        {!isEventActive && (
          <p className="text-sm text-red-600">This event is no longer active</p>
        )}
        
        {ticketsAvailable === 0n && (
          <p className="text-sm text-red-600">This event is sold out</p>
        )}
      </div>
    </div>
  );
}
```

### Ticket Display Component

```typescript
// components/TicketCard.tsx
import { useState } from 'react';
import { useContractRead } from 'wagmi';
import { QRCodeSVG } from 'qrcode.react';
import { eventTicketABI } from '../lib/abis';
import { getContractAddress } from '../lib/contracts';

interface TicketCardProps {
  ticketId: string;
  showQR?: boolean;
}

export function TicketCard({ ticketId, showQR = false }: TicketCardProps) {
  const [showQRCode, setShowQRCode] = useState(showQR);

  const { data: ticketData } = useContractRead({
    address: getContractAddress(8453, 'eventTicket'),
    abi: eventTicketABI,
    functionName: 'tickets',
    args: [BigInt(ticketId)],
  });

  const { data: eventData } = useContractRead({
    address: getContractAddress(8453, 'eventTicket'),
    abi: eventTicketABI,
    functionName: 'events',
    args: ticketData ? [ticketData.eventId] : undefined,
    enabled: !!ticketData,
  });

  if (!ticketData || !eventData) {
    return (
      <div className="bg-white shadow rounded-lg p-6 animate-pulse">
        <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
        <div className="h-4 bg-gray-200 rounded w-1/2"></div>
      </div>
    );
  }

  const eventDate = new Date(Number(eventData.date) * 1000);
  const isUsed = ticketData.isUsed;

  return (
    <div className={`bg-white shadow rounded-lg p-6 border-l-4 ${
      isUsed ? 'border-gray-400' : 'border-blue-500'
    }`}>
      <div className="flex justify-between items-start mb-4">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">
            {eventData.name}
          </h3>
          <p className="text-sm text-gray-600">{eventData.venue}</p>
          <p className="text-sm text-gray-600">
            {eventDate.toLocaleDateString()} at {eventDate.toLocaleTimeString()}
          </p>
        </div>
        
        <div className="text-right">
          <p className="text-sm font-medium text-gray-900">
            Seat #{ticketData.seatNumber.toString()}
          </p>
          <p className="text-xs text-gray-500">
            Ticket #{ticketId}
          </p>
          {isUsed && (
            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
              Used
            </span>
          )}
        </div>
      </div>
      
      {showQRCode && (
        <div className="flex justify-center mb-4">
          <div className="bg-white p-4 rounded-lg border">
            <QRCodeSVG
              value={ticketData.qrCode}
              size={200}
              level="M"
              includeMargin={true}
            />
          </div>
        </div>
      )}
      
      <div className="flex justify-between items-center">
        <button
          onClick={() => setShowQRCode(!showQRCode)}
          className="text-sm text-blue-600 hover:text-blue-800"
        >
          {showQRCode ? 'Hide QR Code' : 'Show QR Code'}
        </button>
        
        <div className="text-xs text-gray-500">
          Original Buyer: {ticketData.originalBuyer.slice(0, 6)}...{ticketData.originalBuyer.slice(-4)}
        </div>
      </div>
    </div>
  );
}
```

## State Management

### Context Provider

```typescript
// contexts/TicketingContext.tsx
import { createContext, useContext, useReducer, ReactNode } from 'react';

interface TicketingState {
  events: Event[];
  tickets: Ticket[];
  loading: boolean;
  error: string | null;
}

type TicketingAction =
  | { type: 'SET_LOADING'; payload: boolean }
  | { type: 'SET_ERROR'; payload: string | null }
  | { type: 'ADD_EVENT'; payload: Event }
  | { type: 'ADD_TICKET'; payload: Ticket }
  | { type: 'UPDATE_TICKET'; payload: { id: string; updates: Partial<Ticket> } };

const initialState: TicketingState = {
  events: [],
  tickets: [],
  loading: false,
  error: null,
};

function ticketingReducer(state: TicketingState, action: TicketingAction): TicketingState {
  switch (action.type) {
    case 'SET_LOADING':
      return { ...state, loading: action.payload };
    case 'SET_ERROR':
      return { ...state, error: action.payload };
    case 'ADD_EVENT':
      return { ...state, events: [...state.events, action.payload] };
    case 'ADD_TICKET':
      return { ...state, tickets: [...state.tickets, action.payload] };
    case 'UPDATE_TICKET':
      return {
        ...state,
        tickets: state.tickets.map(ticket =>
          ticket.id === action.payload.id
            ? { ...ticket, ...action.payload.updates }
            : ticket
        ),
      };
    default:
      return state;
  }
}

const TicketingContext = createContext<{
  state: TicketingState;
  dispatch: React.Dispatch<TicketingAction>;
} | null>(null);

export function TicketingProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(ticketingReducer, initialState);

  return (
    <TicketingContext.Provider value={{ state, dispatch }}>
      {children}
    </TicketingContext.Provider>
  );
}

export function useTicketing() {
  const context = useContext(TicketingContext);
  if (!context) {
    throw new Error('useTicketing must be used within a TicketingProvider');
  }
  return context;
}
```

### Custom Hooks

```typescript
// hooks/useEventTickets.ts
import { useContractReads } from 'wagmi';
import { eventTicketABI } from '../lib/abis';
import { getContractAddress } from '../lib/contracts';

export function useEventTickets(eventId: string) {
  const { data, isLoading, error } = useContractReads({
    contracts: [
      {
        address: getContractAddress(8453, 'eventTicket'),
        abi: eventTicketABI,
        functionName: 'events',
        args: [BigInt(eventId)],
      },
    ],
  });

  return {
    event: data?.[0]?.result,
    isLoading,
    error,
  };
}

// hooks/useUserTickets.ts
import { useAccount, useContractReads } from 'wagmi';
import { useState, useEffect } from 'react';

export function useUserTickets() {
  const { address } = useAccount();
  const [ticketIds, setTicketIds] = useState<string[]>([]);

  // This would typically come from an indexer or event logs
  useEffect(() => {
    if (address) {
      // Fetch user's ticket IDs from events or indexer
      fetchUserTicketIds(address).then(setTicketIds);
    }
  }, [address]);

  const { data: tickets, isLoading } = useContractReads({
    contracts: ticketIds.map(id => ({
      address: getContractAddress(8453, 'eventTicket'),
      abi: eventTicketABI,
      functionName: 'tickets',
      args: [BigInt(id)],
    })),
    enabled: ticketIds.length > 0,
  });

  return {
    tickets: tickets?.map(result => result.result).filter(Boolean) || [],
    isLoading,
  };
}

async function fetchUserTicketIds(address: string): Promise<string[]> {
  // Implementation would depend on your indexing solution
  // This could be a subgraph query, API call, or event log parsing
  return [];
}
```

## Error Handling

### Error Boundary Component

```typescript
// components/ErrorBoundary.tsx
import { Component, ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught error:', error, errorInfo);
  }

  public render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="min-h-screen flex items-center justify-center bg-gray-50">
          <div className="max-w-md w-full bg-white shadow-lg rounded-lg p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <svg className="h-8 w-8 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
                </svg>
              </div>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-gray-800">
                  Something went wrong
                </h3>
                <div className="mt-2 text-sm text-gray-500">
                  <p>An unexpected error occurred. Please refresh the page and try again.</p>
                </div>
                <div className="mt-4">
                  <button
                    onClick={() => window.location.reload()}
                    className="text-sm bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
                  >
                    Refresh Page
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
```

### Error Handling Hook

```typescript
// hooks/useErrorHandler.ts
import { useCallback } from 'react';
import { toast } from 'react-hot-toast';

export function useErrorHandler() {
  const handleError = useCallback((error: any, context?: string) => {
    console.error(`Error ${context ? `in ${context}` : ''}:`, error);
    
    let message = 'An unexpected error occurred';
    
    if (error?.reason) {
      message = error.reason;
    } else if (error?.message) {
      if (error.message.includes('user rejected')) {
        message = 'Transaction was cancelled';
      } else if (error.message.includes('insufficient funds')) {
        message = 'Insufficient funds for transaction';
      } else {
        message = error.message;
      }
    }
    
    toast.error(message);
  }, []);

  return { handleError };
}
```

## UI/UX Best Practices

### Loading States

```typescript
// components/LoadingSpinner.tsx
export function LoadingSpinner({ size = 'md' }: { size?: 'sm' | 'md' | 'lg' }) {
  const sizeClasses = {
    sm: 'h-4 w-4',
    md: 'h-8 w-8',
    lg: 'h-12 w-12',
  };

  return (
    <div className="flex justify-center">
      <div className={`animate-spin rounded-full border-b-2 border-blue-600 ${sizeClasses[size]}`}></div>
    </div>
  );
}

// components/SkeletonLoader.tsx
export function SkeletonLoader() {
  return (
    <div className="animate-pulse">
      <div className="bg-gray-200 rounded h-4 w-3/4 mb-2"></div>
      <div className="bg-gray-200 rounded h-4 w-1/2 mb-2"></div>
      <div className="bg-gray-200 rounded h-4 w-5/6"></div>
    </div>
  );
}
```

### Transaction Status

```typescript
// components/TransactionStatus.tsx
import { useWaitForTransaction } from 'wagmi';

interface TransactionStatusProps {
  hash?: `0x${string}`;
  onSuccess?: () => void;
  onError?: (error: Error) => void;
}

export function TransactionStatus({ hash, onSuccess, onError }: TransactionStatusProps) {
  const { data, isLoading, isError, error } = useWaitForTransaction({
    hash,
    onSuccess,
    onError,
  });

  if (!hash) return null;

  return (
    <div className="mt-4 p-4 border rounded-lg">
      {isLoading && (
        <div className="flex items-center text-blue-600">
          <LoadingSpinner size="sm" />
          <span className="ml-2">Transaction pending...</span>
        </div>
      )}
      
      {data && (
        <div className="flex items-center text-green-600">
          <svg className="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
          <span>Transaction confirmed!</span>
        </div>
      )}
      
      {isError && (
        <div className="flex items-center text-red-600">
          <svg className="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
          <span>Transaction failed: {error?.message}</span>
        </div>
      )}
    </div>
  );
}
```

### Responsive Design

```css
/* styles/globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer components {
  .ticket-card {
    @apply bg-white shadow-lg rounded-lg p-6 border-l-4 border-blue-500;
    @apply hover:shadow-xl transition-shadow duration-200;
  }
  
  .btn-primary {
    @apply bg-blue-600 text-white px-4 py-2 rounded-md font-medium;
    @apply hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500;
    @apply disabled:opacity-50 disabled:cursor-not-allowed;
  }
  
  .btn-secondary {
    @apply bg-gray-200 text-gray-900 px-4 py-2 rounded-md font-medium;
    @apply hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500;
  }
  
  .form-input {
    @apply block w-full rounded-md border-gray-300 shadow-sm;
    @apply focus:border-blue-500 focus:ring-blue-500;
  }
}

/* Mobile-first responsive design */
@media (max-width: 640px) {
  .ticket-card {
    @apply p-4;
  }
  
  .grid-responsive {
    @apply grid-cols-1;
  }
}

@media (min-width: 641px) {
  .grid-responsive {
    @apply grid-cols-2;
  }
}

@media (min-width: 1024px) {
  .grid-responsive {
    @apply grid-cols-3;
  }
}
```

This frontend integration guide provides a comprehensive foundation for building user interfaces that interact with the NFT Event Ticketing System smart contracts.