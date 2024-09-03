import React, { useState } from 'react';
import { TextField, Button, Box } from '@mui/material';

type TaxPayerSearchProps = {
  onSearch: (tid: bigint) => void;
};

const TaxPayerSearch: React.FC<TaxPayerSearchProps> = ({ onSearch }) => {
  const [searchTID, setSearchTID] = useState('');

  const handleSearch = () => {
    const tid = BigInt(searchTID);
    onSearch(tid);
  };

  return (
    <Box sx={{ display: 'flex', gap: 2, mb: 4 }}>
      <TextField
        label="Search by TID"
        variant="outlined"
        value={searchTID}
        onChange={(e) => setSearchTID(e.target.value)}
        type="number"
      />
      <Button variant="contained" color="primary" onClick={handleSearch}>
        Search
      </Button>
    </Box>
  );
};

export default TaxPayerSearch;
